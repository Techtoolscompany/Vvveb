<?php

/**
 * Vvveb
 *
 * Copyright (C) 2022  Ziadin Givan
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 */

namespace Vvveb\Component;

use Vvveb\Sql\FunnelSQL;
use Vvveb\System\Component\ComponentBase;
use Vvveb\System\Event;

class Funnel extends ComponentBase {
    public static $defaultOptions = [
        'start' => 0,
        'limit' => 10,
        'site_id' => null,
    ];

    protected $options = [];

    function results() {
        $funnel = new FunnelSQL();
        
        $results = $funnel->getAll(
            $this->options['start'], 
            $this->options['limit'],
            $this->options['site_id']
        );

        if ($results) {
            foreach ($results['funnels'] as &$funnel) {
                if (isset($funnel['date_added'])) {
                    $funnel['date_added_formatted'] = \Vvveb\humanReadableDate($funnel['date_added']);
                }
                
                if (isset($funnel['date_modified'])) {
                    $funnel['date_modified_formatted'] = \Vvveb\humanReadableDate($funnel['date_modified']);
                }
            }
        }

        list($results) = Event::trigger(__CLASS__, __FUNCTION__, $results);

        return $results;
    }
}

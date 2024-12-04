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

use Vvveb\Sql\TemplateSQL;
use Vvveb\System\Component\ComponentBase;
use Vvveb\System\Event;
use Vvveb\System\Images;

class Template extends ComponentBase {
    public static $defaultOptions = [
        'start' => 0,
        'limit' => 10,
        'site_id' => null,
        'category' => null,
    ];

    protected $options = [];

    function results() {
        $template = new TemplateSQL();
        
        if ($this->options['category']) {
            $results = $template->getByCategory(
                $this->options['category'],
                $this->options['site_id'],
                $this->options['start'], 
                $this->options['limit']
            );
        } else {
            $results = $template->getAll(
                $this->options['start'], 
                $this->options['limit'],
                $this->options['site_id']
            );
        }

        if ($results) {
            foreach ($results['templates'] as &$template) {
                if (isset($template['date_added'])) {
                    $template['date_added_formatted'] = \Vvveb\humanReadableDate($template['date_added']);
                }
                
                if (isset($template['date_modified'])) {
                    $template['date_modified_formatted'] = \Vvveb\humanReadableDate($template['date_modified']);
                }

                if (isset($template['thumb'])) {
                    $template['thumb'] = Images::image($template['thumb'], 'template');
                }

                // Add template type labels
                switch($template['type']) {
                    case 'page':
                        $template['type_label'] = 'Full Page';
                        break;
                    case 'section':
                        $template['type_label'] = 'Section';
                        break;
                    case 'component':
                        $template['type_label'] = 'Component';
                        break;
                    default:
                        $template['type_label'] = ucfirst($template['type']);
                }

                // Add template category labels
                switch($template['category']) {
                    case 'landing':
                        $template['category_label'] = 'Landing Page';
                        break;
                    case 'sales':
                        $template['category_label'] = 'Sales Page';
                        break;
                    case 'checkout':
                        $template['category_label'] = 'Checkout Page';
                        break;
                    case 'thank-you':
                        $template['category_label'] = 'Thank You Page';
                        break;
                    default:
                        $template['category_label'] = ucfirst($template['category']);
                }
            }
        }

        list($results) = Event::trigger(__CLASS__, __FUNCTION__, $results);

        return $results;
    }

    function categories() {
        $template = new TemplateSQL();
        $categories = $template->getCategories($this->options['site_id']);

        if ($categories) {
            // Build category tree
            $tree = [];
            foreach ($categories['categories'] as $category) {
                if (!$category['parent_id']) {
                    $tree[$category['category_id']] = $category;
                    $tree[$category['category_id']]['children'] = [];
                } else {
                    $tree[$category['parent_id']]['children'][] = $category;
                }
            }
            $categories['tree'] = $tree;
        }

        list($categories) = Event::trigger(__CLASS__, __FUNCTION__, $categories);

        return $categories;
    }
}

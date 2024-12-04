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

namespace Vvveb\Controller\Funnel;

use Vvveb\Controller\Base;
use Vvveb\Sql\FunnelSQL;
use Vvveb\System\Images;
use Vvveb\System\Sites;
use function Vvveb\__;

class Funnel extends Base {
    protected $type = 'funnel';

    function index() {
        $view = $this->view;
        $funnelSql = new FunnelSQL();

        $site_id = $this->global['site_id'];
        
        $options = [
            'type' => $this->type,
        ];

        $results = $funnelSql->getAll(
            $this->global['start'], 
            $this->global['limit'],
            $site_id
        );

        if ($results) {
            $view->funnels = $results['funnels'];
            $view->count = $results['count'];
        }
    }

    function edit() {
        $view = $this->view;
        $funnelSql = new FunnelSQL();
        
        $site_id = $this->global['site_id'];
        $funnel_id = $this->request->get['funnel_id'] ?? false;

        if ($funnel_id) {
            $funnel = $funnelSql->get($funnel_id, $site_id);
            
            if ($funnel) {
                $view->funnel = $funnel['funnel'];
                $view->steps = $funnel['steps'] ?? [];
            }
        }
    }

    function save() {
        $funnelSql = new FunnelSQL();
        $site_id = $this->global['site_id'];
        $funnel_id = $this->request->get['funnel_id'] ?? false;
        $funnel = $this->request->post['funnel'] ?? [];
        $steps = $this->request->post['steps'] ?? [];

        if (!$funnel) {
            return $this->redirect('funnel/funnel/index', ['error' => __('Missing funnel data!')]);
        }

        try {
            if ($funnel_id) {
                // Update funnel
                $funnelSql->edit([
                    'funnel' => $funnel,
                    'funnel_id' => $funnel_id,
                    'site_id' => $site_id
                ]);

                // Update steps
                if ($steps) {
                    foreach ($steps as $step) {
                        if (isset($step['step_id'])) {
                            $funnelSql->editStep([
                                'funnel_step' => $step,
                                'step_id' => $step['step_id']
                            ]);
                        } else {
                            $funnelSql->addStep([
                                'funnel_step' => $step,
                                'funnel_id' => $funnel_id
                            ]);
                        }
                    }
                }

                $this->view->success[] = __('Funnel saved!');
            } else {
                // Add new funnel
                $funnel_id = $funnelSql->add([
                    'funnel' => $funnel,
                    'site_id' => $site_id
                ]);

                // Add steps
                if ($steps && $funnel_id) {
                    foreach ($steps as $step) {
                        $funnelSql->addStep([
                            'funnel_step' => $step,
                            'funnel_id' => $funnel_id
                        ]);
                    }
                }

                $this->view->success[] = __('Funnel created!');
            }
        } catch (\Exception $e) {
            $this->view->errors[] = $e->getMessage();
        }

        return $this->redirect('funnel/funnel/edit', ['funnel_id' => $funnel_id]);
    }

    function delete() {
        $funnelSql = new FunnelSQL();
        $site_id = $this->global['site_id'];
        $funnel_id = $this->request->post['funnel_id'] ?? false;

        if (!$funnel_id) {
            return $this->redirect('funnel/funnel/index', ['error' => __('Missing funnel id!')]);
        }

        try {
            $funnelSql->delete($funnel_id, $site_id);
            $this->view->success[] = __('Funnel deleted!');
        } catch (\Exception $e) {
            $this->view->errors[] = $e->getMessage();
        }

        return $this->redirect('funnel/funnel/index');
    }

    function deleteStep() {
        $funnelSql = new FunnelSQL();
        $step_id = $this->request->post['step_id'] ?? false;
        $funnel_id = $this->request->post['funnel_id'] ?? false;

        if (!$step_id) {
            return $this->redirect('funnel/funnel/edit', ['funnel_id' => $funnel_id, 'error' => __('Missing step id!')]);
        }

        try {
            $funnelSql->deleteStep($step_id);
            $this->view->success[] = __('Step deleted!');
        } catch (\Exception $e) {
            $this->view->errors[] = $e->getMessage();
        }

        return $this->redirect('funnel/funnel/edit', ['funnel_id' => $funnel_id]);
    }
}

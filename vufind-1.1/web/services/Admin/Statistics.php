<?php
/**
 * Statistics action for Admin module
 *
 * PHP version 5
 *
 * Copyright (C) Villanova University 2007.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * @category VuFind
 * @package  Controller_Admin
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Admin.php';

/**
 * Statistics action for Admin module
 *
 * @category VuFind
 * @package  Controller_Admin
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class Statistics extends Admin
{
    /**
     * Process parameters and display the page.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        global $configArray;
        global $interface;

        // Load SOLR Statistics
        $solr = ConnectionManager::connectToIndex('SolrStats');

        // All Statistics
        $result = $solr->search(
            '*:*', null, null, 0, null,
            array('field' => array('ipaddress', 'browser')), '', null, null, null,
            HTTP_REQUEST_METHOD_GET
        );
        if (!PEAR::isError($result)) {
            if (isset($result['facet_counts']['facet_fields']['ipaddress'])) {
                $interface->assign(
                    'ipList', $result['facet_counts']['facet_fields']['ipaddress']
                );
            }
            if (isset($result['facet_counts']['facet_fields']['browser'])) {
                $interface->assign(
                    'browserList',
                    $result['facet_counts']['facet_fields']['browser']
                );
            }
        }

        // Search Statistics
        $result = $solr->search(
            'phrase:[* TO *]', null, null, 0, null,
            array('field' => array('noresults', 'phrase')),
            '', null, null, null, HTTP_REQUEST_METHOD_GET
        );
        if (!PEAR::isError($result)) {
            $interface->assign('searchCount', $result['response']['numFound']);

            // Extract the count of no hit results by finding the "no hit" facet
            // entry set to boolean true.
            $nohitCount = 0;
            $nhFacet = & $result['facet_counts']['facet_fields']['noresults'];
            if (isset($nhFacet) && is_array($nhFacet)) {
                foreach ($nhFacet as $nhRow) {
                    if ($nhRow[0] == 'true') {
                        $nohitCount = $nhRow[1];
                    }
                }
            }
            $interface->assign('nohitCount', $nohitCount);

            $interface->assign(
                'termList', $result['facet_counts']['facet_fields']['phrase']
            );
        }

        // Record View Statistics
        $result = $solr->search(
            'recordId:[* TO *]', null, null, 0, null,
            array('field' => array('recordId')),
            '', null, null, null, HTTP_REQUEST_METHOD_GET
        );
        if (!PEAR::isError($result)) {
            $interface->assign('recordViews', $result['response']['numFound']);
            $interface->assign(
                'recordList', $result['facet_counts']['facet_fields']['recordId']
            );
        }

        $interface->setTemplate('statistics.tpl');
        $interface->setPageTitle('Statistics');
        $interface->display('layout-admin.tpl');
    }
}

?>
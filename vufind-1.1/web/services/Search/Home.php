<?php
/**
 * Home action for Search module
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
 * @package  Controller_Search
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Action.php';
require_once 'RecordDrivers/Utils.php';
require_once 'services/Search/easyrdf/lib/EasyRdf.php';

/**
 * Home action for Search module
 *
 * @category VuFind
 * @package  Controller_Search
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class Home extends Action
{
    /**
     * Process incoming parameters and display the page.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        global $interface;

        // Cache homepage
        $interface->caching = 0;
        $cacheId = 'homepage|' . $interface->lang . '|' .
            (UserAccount::isLoggedIn() ? '1' : '0');
        if (!$interface->is_cached('layout.tpl', $cacheId)) {
            $interface->setPageTitle('Search Home');
            $interface->assign('searchTemplate', 'search.tpl');
            $interface->setTemplate('home.tpl');


            // Create our search object
            $searchObject = SearchObjectFactory::initSearchObject();
            // Re-use the advanced search facets method,
            //   it is (for now) calling the same facets.
            // The template however is looking for specific
            //   facets. Bear in mind for later.
            $searchObject->initAdvancedFacets();
            // We don't want this search in the search history
            $searchObject->disableLogging();
            // Go get the facets
            $searchObject->processSearch();
            $facetList = $searchObject->getFacetList();
            // Shutdown the search object
            $searchObject->close();

            $interface->assign("messageOfTheDay", $this->addMessageOfTheDay());

            // Add a sorted version to the facet list:
            if (count($facetList) > 0) {
                $facets = array();
                foreach ($facetList as $facet => $details) {
                    $facetList[$facet]['sortedList'] = array();
                    foreach ($details['list'] as $value) {
                        $facetList[$facet]['sortedList'][$value['value']]
                            = $value['url'];
                    }
                    natcasesort($facetList[$facet]['sortedList']);
                }
                $interface->assign('facetList', $facetList);
            }
        }
        $interface->display('layout.tpl', $cacheId);
    }

    private function addMessageOfTheDay()
    {
        global $interface;
        global $configArray;

        $messageOfTheDay = translate('messageOfTheDay');
        if ($messageOfTheDay) {
            $language = $interface->getLanguage();
            $motd = $configArray['IISH']['cache'] . '/motd_' . $language . '.txt';
            $text = $this->useCache($motd) ? file_get_contents($motd) : null;
            if ($text == null) {
                $graph = null;
                try {
                    $graph = EasyRdf_Graph::newAndLoad($messageOfTheDay);
                } catch (Exception $e) {
                    return null;
                }
                $title = $graph->label();
                $content = $graph->get(
                    $messageOfTheDay,
                    'content:encoded',
                    'literal',
                    $interface->lang);
                if ($content)
                    $text = serialize( array(title => $title, content => str_replace('.', '. ', $content), lang => $content . lang));
                    file_put_contents($motd, $text);
            }

            if ( $text )
                return unserialize($text);

        }
        return null;
    }

    private function useCache($file)
    {
        global $configArray;
        return !isset($_GET['nocache']) && is_readable($file) &&
            $configArray['IISH']['cacheExpiration'] &&
            filectime($file) > (time() - $configArray['IISH']['cacheExpirationMotd']);
    }

}

?>

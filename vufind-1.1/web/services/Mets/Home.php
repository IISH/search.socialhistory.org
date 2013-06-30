<?php
/**
 * Home action for Record module
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
 * @package  Controller_Record
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Action.php';
require_once 'services/Record/xsl/Lang.php';

/**
 * Home action for Record module
 *
 * @category VuFind
 * @package  Controller_Record
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
        $lang = $interface->getLanguage();
        $interface->assign('lang', $lang);

        $metsId = isset($_GET['metsId']) ? $_GET['metsId'] : null;
        if ($metsId == null) {
            header("HTTP/1.0 404 Not Found");
            header("Status: 404 Not Found");
            return;
        }

        $doc = new DOMDocument();
        $doc->load($metsId);
        if ($doc == null) {
            header("HTTP/1.0 404 Not Found");
            header("Status: 404 Not Found");
            return;
        }


        global $configArray;
        global $interface;
        $page = isset($_GET['page']) ? $_GET['page'] : 1;
        $rows = isset($_GET['rows']) ? $_GET['rows'] : $configArray['IISH']['visualmets.rows'];

        $style = new DOMDocument;
        $style->load('services/Record/xsl/mets.xsl');
        $xsl = new XSLTProcessor();
        $xsl->importStylesheet($style);
        $xsl->registerPHPFunctions('Lang::translate');
        $xsl->setParameter('', 'lang', $lang);
        $xsl->setParameter('', 'metsId', $metsId);
        $xsl->setParameter('', 'level', 'level3');
        $xsl->setParameter('', 'page', $page);
        $xsl->setParameter('', 'rows', $rows);
        $xsl->setParameter('', 'visualmets', $configArray['IISH']['visualmets.url']);
        $body = $xsl->transformToXML($doc);
        $interface->assign('body', $body);

        $interface->display('Mets/home.tpl');
    }
}

?>
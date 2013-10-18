<?php
/**
 * MARC Record Driver
 *
 * PHP version 5
 *
 * Copyright (C) Villanova University 2010.
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
 * @package  RecordDrivers
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/other_than_marc Wiki
 */
require_once 'RecordDrivers/MarcRecord.php';
require_once 'RecordDrivers/Utils.php';
require_once 'services/Record/xsl/ArchiveUtil.php';

/**
 * EAD Record Driver
 *
 * This class is designed to handle MARC records.  Much of its functionality
 * is inherited from the default index-based driver.
 *
 * @category VuFind
 * @package  RecordDrivers
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 */
class EadRecord extends MarcRecord
{
    /**
     * Constructor.  We build the object using all the data retrieved
     * from the (Solr) index (which also happens to include the
     * 'fullrecord' field containing raw metadata).  Since we have to
     * make a search call to find out which record driver to construct,
     * we will already have this data available, so we might as well
     * just pass it into the constructor.
     *
     * @param array $record All fields retrieved from the index.
     *
     * @access public
     */
    public function __construct($record)
    {
        // Call the parent's constructor...
        parent::__construct($record);
    }

    /**
     * Assign necessary Smarty variables and return a template name to
     * load in order to display a summary of the item suitable for use in
     * search results.
     *
     * @return string Name of Smarty template file to display.
     * @access public
     */
    public function getSearchResult()
    {
        global $interface;

        parent::getSearchResult();

        // EAD results...
        $interface->assign('summAjaxStatus', false);

        // Assign only the first piece of summary data for the core; we'll get the
        // rest as part of the extended data.
        $period = $this->getPeriod();
        $interface->assign('summPeriod', $period);
        $summary = $this->getSummary();
        $summary = count($summary) > 0 ? $summary[0] : null;
        $interface->assign('summSummary', $summary);

        // We dont want to display the full text
        $interface->assign('summURLs', null);

        return 'RecordDrivers/Ead/result.tpl';
    }

    private function getPeriod()
    {
        $period = $this->_getFieldArray('245', array('g'), false);
        $period = count($period) > 0 ? $period[0] : null;
        return $period;
    }

    public function getCoreMetadata()
    {
        parent::getCoreMetadata();

        global $interface;
        $doc = Utils::getOAIRecord($this->getUniqueID(), $this->getOAIPid(), 'ead');
        if (!$doc) {
            PEAR::RaiseError(new PEAR_Error('Record not found in OAI service: ' + $this->getOAIPid()));
            die();
        }

        global $configArray;
        $interface->assign('visualmets_url', $configArray['IISH']['visualmets.url']);
        $interface->assign('visualmets_rows', $configArray['IISH']['visualmets.rows']);
        $interface->assign('ead', $this->getEADArray($doc));
        $interface->assign('baseUrl', '/Record/' . $this->getUniqueID());
        return 'RecordDrivers/Ead/core.tpl';
    }

    /**
     * Parse the EAD as an array.
     * It has descgrp as the main keys:
     * descgrp['context' ... '']
     */
    private function getEADArray($doc)
    {
        $action = (isset($_REQUEST["action"]))
            ? $_REQUEST["action"]
            : "ArchiveCollectionSummary";
        if ($action == "Description") $action = "ArchiveCollectionSummary";

        $style = new DOMDocument;
        $stylesheet = 'services/Record/xsl/record-ead-' . $action . '.xsl';
        $style->load($stylesheet);
        $xsl = new XSLTProcessor();
        $xsl->registerPHPFunctions('ArchiveUtil::generateID');
        $xsl->registerPHPFunctions('ArchiveUtil::translate');
        $xsl->registerPHPFunctions('ArchiveUtil::truncate');
        $xsl->importStyleSheet($style);
        $xsl->setParameter('', 'action', $action);
        $xsl->setParameter('', 'baseUrl', '/Record/' . $this->getUniqueID());
        $xsl->setParameter('', 'title', parent::getTitle());
        global $interface;
        $xsl->setParameter('', 'lang', $interface->getLanguage());

        $result = $xsl->transformToXML($doc);
        if (!$result) {
            //PEAR::RaiseError(new PEAR_Error('Failed to compile xsl stylesheet ' + $stylesheet));
            return null;
        }
        return $result;
    }

    public function getNavigation()
    {

    }

    /**
     * Get an array of strings representing formats in which this record's
     * data may be exported (empty if none).  Legal values: "RefWorks",
     * "EndNote", "MARC", "RDF".
     *
     * @return array Strings representing export formats.
     * @access public
     */
    public function getExportFormats()
    {
        $formats = parent::getExportFormats();
        // These are the formats we can possibly support if they are turned on in
        // config.ini:
        $possible = array('EAD', 'PDF');

        // Check which formats are currently active:
        global $configArray;
        $active = isset($configArray['Export']) ?
            $configArray['Export'] : array();
        foreach ($possible as $current) {
            if ($active[$current]) {
                $formats[] = $current;
            }
        }

        // Add API url
        global $interface;
        $interface->assign('oaiBaseUrl', $configArray['IISH']['oaiBaseUrl']);
        $interface->assign('oaiPid', $this->getOAIPid());
        $interface->assign('pdfFile', md5($this->getUniqueID() . '_ead') . '.pdf');


        // Send back the results:
        return $formats;
    }
}

?>

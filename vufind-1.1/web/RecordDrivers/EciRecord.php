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
class EciRecord extends MarcRecord
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

    public function getSearchResult()
    {
        parent::getSearchResult();
        return 'RecordDrivers/Eci/result.tpl';
    }

    public function getCoreMetadata()
    {
        parent::getCoreMetadata();
        return 'RecordDrivers/Eci/core.tpl';
    }

    public function getExtendedMetadata()
    {
        global $interface;
        $details = $this->getDetails(Utils::getResource($this->getUniqueID(), $this->getOAIPid(), 'eci'));
        $interface->assign('details', $details);
        return 'RecordDrivers/Eci/extended.tpl';
    }

    public function getStaffView()
    {
        parent::getStaffView();

        global $interface;
        $staffURLs = $this->getURLs();
        $interface->assign('staffURLs', $staffURLs);
        return 'RecordDrivers/Eci/staff.tpl';
    }

    public function getHoldings()
    {
        global $interface;
        $details = $this->getDetails(Utils::getResource($this->getUniqueID(), $this->getOAIPid(), 'eci'));
        $interface->assign('details', $details);
        return 'RecordDrivers/Eci/holdings.tpl';
    }

    private function getDetails($xml)
    {
        $action = (isset($_REQUEST["action"]))
                ? $_REQUEST["action"]
                : "Holdings";
        // Prevent unprintable characters from interfering with the XSL transform:
        $xml = str_replace(array(chr(29), chr(30), chr(31)), ' ', $xml);
        $style = new DOMDocument;
        $style->load('services/Record/xsl/record-eci.xsl');
        $xsl = new XSLTProcessor();
        $xsl->importStyleSheet($style);
        $xsl->setParameter('', "notgeschiedenis", translate('notgeschiedenis'));
        $xsl->setParameter('', "action", $action);
        $doc = new DOMDocument();
        if ($doc->loadXML($xml)) {
            $html = $xsl->transformToXML($doc);
            return $html;
        }
        return false;
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
        $possible = array('ECI');

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

        // Send back the results:
        return $formats;
    }
}

?>
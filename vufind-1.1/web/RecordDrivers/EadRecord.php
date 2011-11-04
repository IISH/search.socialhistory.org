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
require_once 'services/Record/xsl/TimePeriods.php';

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

    public function getCoreMetadata()
    {
        parent::getCoreMetadata();

        global $interface;

        $period = $this->getPeriod();
        $corePhysical = $this->getPhysical();
        $geography = $this->getGeography();
        $accessRestrictions = $this->getAccessRestrictions();
        $authorAndRole = $this->getAuthorAndRole();
        $interface->assign('corePeriod', $period);
        $interface->assign('corePhysical', $corePhysical);
        $interface->assign('coreAuthor', $authorAndRole[0]);
        $interface->assign('coreAuthorRole', $authorAndRole[1]);
        $interface->assign('coreGeography', $geography);
        $interface->assign('coreAccess', $accessRestrictions);

        return 'RecordDrivers/Ead/core.tpl';
    }

    public function getExtendedMetadata()
    {
        global $interface;
        $details = $this->getDetails(Utils::getResource($this->getUniqueID(), 'ead'));
        $interface->assign('details', $details);
        return 'RecordDrivers/Ead/extended.tpl';
    }

    private function getPeriod()
    {
        $period = $this->_getFieldArray('245', array('g'), false);
        $period = count($period) > 0 ? $period[0] : null;
        return $period;
    }

    private function getPhysical()
    {
        $physical = $this->_getFieldArray('300', array('d'), false);
        $physical = count($physical) > 0 ? $physical[0] : null;
        return $physical;
    }

    /**
     * Retrieve author2 and role from the Marc field. We could have uses the Solr fields as well for this.
     *
     * @return array
     */
    private function getAuthorAndRole()
    {
        $collector = $this->_getFieldArray('700', array('a', 'e'), false);
        if (sizeof($collector) == 0)
            $collector = $this->_getFieldArray('710', array('a', 'e'), false);
        if (sizeof($collector) == 0)
            $collector = $this->_getFieldArray('711', array('a', 'e'), false);
        if (sizeof($collector) == 1)
            $collector[] = "Author";
        return $collector;
    }

    private function getGeography()
    {
        return null;
    }

    /**
     * Get access restriction notes for the record.
     *
     * @return array
     * @access protected
     */
    protected function getAccessRestrictions()
    {
        $accessRestrictions = $this->_getFieldArray('506', array('a', 'b'), false);
        if (sizeof($accessRestrictions) == 2) {
            $pos1 = strpos($accessRestrictions[0], 'Beperkt');
            $pos2 = strpos($accessRestrictions[0], 'Restricted');
            if ($pos1 != -1 || $pos2 != -1)
                $accessRestrictions[] = "consultation";
        }
        return $accessRestrictions;
    }

    public function getStaffView()
    {
        parent::getStaffView();

        global $interface;
        $staffURLs = $this->getURLs();
        $interface->assign('staffURLs', $staffURLs);
        return 'RecordDrivers/Ead/staff.tpl';
    }

    public function getHoldings()
    {
        global $interface;
        global $configArray;
        $id = $this->getUniqueID();
        $details = $this->getDetails(Utils::getResource($id, 'ead'));
        $interface->assign('details', $details);

        // Add the deliverance API
        $deliverance = $configArray['IISH']['deliverance'];
        $interface->assign('deliverance', $deliverance);
        $interface->assign('pid', $this->getUniqueID()); // Todo: replace with PID in 902$a

        return 'RecordDrivers/Ead/holdings.tpl';

        /* global $interface;
       $details = $this->getTimelines(Utils::getResource($this->getUniqueID(), 'ead'));
       $interface->assign('details', $details);
       return 'RecordDrivers/Av/holdings.tpl'*/
        ;
    }

    private function getDetails($xml)
    {
        $action = (isset($_REQUEST["action"]))
                ? $_REQUEST["action"]
                : "Holdings";
        $accessRestrictions = $this->getAccessRestrictions();
        $physical = $this->getMetric($this->getPhysical());

        // Prevent unprintable characters from interfering with the XSL transform:
        $xml = str_replace(array(chr(29), chr(30), chr(31)), ' ', $xml);
        $style = new DOMDocument;
        $style->load('services/Record/xsl/record-ead.xsl');
        $xsl = new XSLTProcessor();
        $xsl->importStyleSheet($style);
        $xsl->setParameter('', "action", $action);
        $xsl->setParameter('', "notgeschiedenis", translate('notgeschiedenis'));
        $xsl->setParameter('', "access", $accessRestrictions[0]);
        $xsl->setParameter('', "physical", $physical);
        $xsl->setParameter('', "large_archive", translate('large_archive'));
        $xsl->setParameter('', "no_inventory", translate('no_inventory'));
        $doc = new DOMDocument();
        if ($doc->loadXML($xml)) {
            $html = $xsl->transformToXML($doc);
            return $html;
        }
        return false;
    }

/*    private function getTimelines($xml)
    {
        $action = (isset($_REQUEST["action"]))
                ? $_REQUEST["action"]
                : "Holdings";
        // Prevent unprintable characters from interfering with the XSL transform:
        $xml = str_replace(array(chr(29), chr(30), chr(31)), ' ', $xml);
        $style = new DOMDocument;
        $style->load('services/Record/xsl/ead-timelines.xsl');
        $xsl = new XSLTProcessor();
        $xsl->importStyleSheet($style);
        $xsl->setParameter('', "notgeschiedenis", translate('notgeschiedenis'));
        $xsl->setParameter('', "action", $action);
        $xsl->registerPHPFunctions("TimePeriods::getDates");
        $doc = new DOMDocument();
        if ($doc->loadXML($xml)) {
            $html = $xsl->transformToXML($doc);
            return $html;
        }
        return false;
    }*/

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

        // Send back the results:
        return $formats;
    }

    /**
     * In the
     *
     * @return bool
     */
    public function hasTOC()
    {
        //10716410_EAD
        // Do we have a table of contents stored in the index?
        return (isset($this->fields['contents']) &&
                count($this->fields['contents']) > 0);
    }


    public function getTOC()
    {
        $xml = Utils::getResource($this->getUniqueID(), 'ead');
        $xml = str_replace(array(chr(29), chr(30), chr(31)), ' ', $xml);
        $style = new DOMDocument;
        $style->load('services/Record/xsl/record-ead-toc.xsl');
        $xsl = new XSLTProcessor();
        $xsl->importStyleSheet($style);
        $doc = new DOMDocument();
        if ($doc->loadXML($xml)) {
            global $interface;
            $html = $xsl->transformToXML($doc);
            $interface->assign('toc', $html);
        }
        return 'RecordDrivers/Ead/toc.tpl';
    }


/*    private function _getFieldArray($field, $subfields = null, $concat = true)
    {
        // Default to subfield a if nothing is specified.
        if (!is_array($subfields)) {
            $subfields = array('a');
        }

        // Initialize return array
        $matches = array();

        // Try to look up the specified field, return empty array if it doesn't
        // exist.
        $fields = $this->marcRecord->getFields($field);
        if (!is_array($fields)) {
            return $matches;
        }

        // Extract all the requested subfields, if applicable.
        foreach ($fields as $currentField) {
            $next = $this->_getSubfieldArray($currentField, $subfields, $concat);
            $matches = array_merge($matches, $next);
        }

        return $matches;
    }*/

    /**
     * Get the first value matching the specified MARC field and subfields.
     * If multiple subfields are specified, they will be concatenated together.
     *
     * @param string $field     The MARC field to read
     * @param array  $subfields The MARC subfield codes to read
     *
     * @return string
     * @access private
     */
    /*private function _getFirstFieldValue($field, $subfields = null)
    {
        $matches = $this->_getFieldArray($field, $subfields);
        return (is_array($matches) && count($matches) > 0) ?
                $matches[0] : null;
    }*/

/*    private function _getSubfieldArray($currentField, $subfields, $concat = true)
    {
        // Start building a line of text for the current field
        $matches = array();
        $currentLine = '';

        // Loop through all specified subfields, collecting results:
        foreach ($subfields as $subfield) {
            $subfieldsResult = $currentField->getSubfields($subfield);
            if (is_array($subfieldsResult)) {
                foreach ($subfieldsResult as $currentSubfield) {
                    // Grab the current subfield value and act on it if it is
                    // non-empty:
                    $data = trim($currentSubfield->getData());
                    if (!empty($data)) {
                        // Are we concatenating fields or storing them separately?
                        if ($concat) {
                            $currentLine .= $data . ' ';
                        } else {
                            $matches[] = $data;
                        }
                    }
                }
            }
        }

        // If we're in concat mode and found data, it will be in $currentLine and
        // must be moved into the matches array.  If we're not in concat mode,
        // $currentLine will always be empty and this code will be ignored.
        if (!empty($currentLine)) {
            $matches[] = trim($currentLine);
        }

        // Send back our result array:
        return $matches;
    }*/

    private function getMetric($physical)
    {
        $pattern = "([1-9][0-9][0-9]|[1-9][0-9]|[1-9])"; // 1..999 range
        preg_match($pattern, $physical, $matches);
        if (sizeof($matches) == 0)
            return 0;
        return $matches[0];
    }
}

?>
<?php
/**
 * AV Record Driver    ( a marc record, but with a minor adjustment for audio\visual material )
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

/**
 * MARC Record Driver
 *
 * This class is designed to handle MARC records.  Much of its functionality
 * is inherited from the default index-based driver.
 *
 * @category VuFind
 * @package  RecordDrivers
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/other_than_marc Wiki
 */
class AvRecord extends MarcRecord
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
        $tpl = parent::getSearchResult();
        // We dont want to display the full text, because here it is an image.
        global $interface;
        $interface->assign('summAjaxStatus', false);
        $interface->assign('summURLs', null);
        return $tpl;
    }

    public function getCoreMetadata()
    {
        $tpl = parent::getCoreMetadata();
        global $interface;
        $barcode = $this->getBarcode();
        $interface->assign('coreBarcode', $barcode);
        //$coreNotes = $this->getNotes();
        //$interface->assign('coreNotes', $coreNotes);
        $interface->assign('coreCopyrightA', $this->getCopyright('a'));
        $interface->assign('coreCopyrightB', $this->getCopyright('b'));
        $corePeriod = $this->getPeriod();
        $interface->assign('corePeriod', $corePeriod);
        $coreGenres = $this->getGenres();
        $coreHolding = $this->getHolding();
        $interface->assign('coreHolding', $coreHolding);
        $interface->assign('coreGenres', $coreGenres);
        $interface->assign('coreURLs', null);
        $interface->assign('recordLanguage', null);
        $interface->assign('coreMarc600', $this->_getFieldArray('600'));
        $interface->assign('coreMarc610', $this->_getFieldArray('610'));
        $interface->assign('coreMarc611', $this->getMeeting());
        $interface->assign('coreMarc650', $this->_getFieldArray('650'));
        $interface->assign('coreMarc651', $this->_getFieldArray('651'));

        $this->getExtendedMetadata();

        return $tpl;
    }

    protected function getPublicationDates(){
        $date = $this->_getFieldArray('260', array('c'));
        return isset($date) ? $date : array();
    }

    protected function getMarc6xx($field) {
        return $this->_getFieldArray($field);
    }

    private function getBarcode()
    {
        $barcode = $this->_getFirstFieldValue('852', array('p'));
        return $barcode;
    }

    private function getCopyRight($subfield)
    {
        $copyright = $this->_getFirstFieldValue('540', array($subfield));
        return $copyright;
    }

    private function getPeriod()
    {
        return $this->_getFieldArray('648');
    }

    private function getGenres()
    {
        $genre = isset($this->fields['genre']) ? $this->fields['genre'] : array();
        $retval = array();
        foreach ($genre as $g) {
            $retval[] = array($g);
        }
        return $retval;
    }

    protected function getAllSubjectHeadings()
    {
        // These are the fields that may contain subject headings:
        $fields = array('600', '610', '630', '650', '651');

        // This is all the collected data:
        $retval = array();

        // Try each MARC field one at a time:
        foreach ($fields as $field) {
            // Do we have any results for the current field?  If not, try the next.
            $results = $this->marcRecord->getFields($field);
            if (!$results) {
                continue;
            }

            // If we got here, we found results -- let's loop through them.
            foreach ($results as $result) {
                // Start an array for holding the chunks of the current heading:
                $current = array();

                // Get all the chunks and collect them together:
                $subfields = $result->getSubfields();
                if ($subfields) {
                    foreach ($subfields as $subfield) {
                        // Numeric subfields are for control purposes and should not
                        // be displayed:
                        if (!is_numeric($subfield->getCode())) {
                            $current[] = $subfield->getData();
                        }
                    }
                    // If we found at least one chunk, add a heading to our result:
                    if (!empty($current)) {
                        $retval[] = $current;
                    }
                }
            }
        }

        // Send back everything we collected:
        return $retval;
    }

    private function getMeeting()    {
        return $this->_getFieldArray('611', array('a', 'e', 'n', 'd', 'c'));
    }

}

?>

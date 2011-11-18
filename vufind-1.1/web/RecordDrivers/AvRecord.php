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
        $coreNotes = $this->getNotes();
        $interface->assign('coreNotes', $coreNotes);
        $coreCopyright = $this->getCopyRight();
        $interface->assign('coreCopyright', $coreCopyright);
        $corePeriod = $this->getPeriod();
        $interface->assign('corePeriod', $corePeriod);
        $coreGenres = $this->getGenres();
        $coreHolding = $this->getHolding();
        $interface->assign('coreHolding', $coreHolding);
        $interface->assign('coreGenres', $coreGenres);
        $interface->assign('coreURLs', null);
        $interface->assign('recordLanguage', null);
        return $tpl;
    }

    private function getBarcode()
    {
        $barcode = $this->_getFirstFieldValue('852', array('p'));
        return $barcode;
    }

    private function getNotes()
    {
        $notes = $this->_getFirstFieldValue('500', array('a'));
        return $notes;
    }

    private function getCopyRight()
    {
        $copyright = $this->_getFirstFieldValue('540', array('b'));
        return $copyright;
    }

    private function getPeriod()
    {
        $period = $this->_getFirstFieldValue('648', array('a'));
        return $period;
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

    /**
    Just return the barcode for now...
     */
    private function getAudioVisual()
    {
        $urls = $this->getURLs();
        foreach ($urls as $url) {
            $pos = strpos($url, "/10622/");
            if ($pos > 1) {
                return substr($url, $pos + 7);
            }
        }
        return false;
    }

    protected function getThumbnail($size = 'small')
    {
        global $configArray;

        if ($audiovisual = $this->getAudioVisual()) { // In this case, the isn is the PID
            return $configArray['Site']['url'] . '/bookcover.php?isn=' .
                   $audiovisual . '&size=' . urlencode($size);
        }

        return false;
    }

/*    private function _getFirstFieldValue($field, $subfields = null)
    {
        $matches = $this->_getFieldArray($field, $subfields);
        return (is_array($matches) && count($matches) > 0) ?
                $matches[0] : null;
    }*/

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
}

?>

<?php
/**
 * Hold action for Record module
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

/**
 * Hold action for Record module
 *
 * @category VuFind
 * @package  Controller_Record
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class Hold extends Action
{
    private $_catalog;

    /**
     * Process incoming parameters and display the page.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        $this->_catalog = ConnectionManager::connectToCatalog();

        // Check How to Process Hold
        if (method_exists($this->_catalog->driver, 'placeHold')) {
            $this->_placeHold();
        } elseif (method_exists($this->_catalog->driver, 'getHoldLink')) {
            // Redirect user to Place Hold screen on ILS OPAC
            $link = $this->_catalog->getHoldLink($_GET['id']);
            if (!PEAR::isError($link)) {
                header('Location:' . $link);
            } else {
                PEAR::raiseError($link);
            }
        } else {
            PEAR::raiseError(
                new PEAR_Error('Cannot Process Place Hold - ILS Not Supported')
            );
        }
    }

    /**
     * Support method to actually place the hold.
     *
     * @return void
     * @access private
     */
    private function _placeHold()
    {
        global $interface;

        $interface->assign('id', $_GET['id']);
        $holding = $this->_catalog->getHolding($_GET['id']);
        if (PEAR::isError($holding)) {
            PEAR::raiseError($holding);
        }
        $interface->assign('holding', $holding);

        if (isset($_POST['id'])) {
            $patron = $this->_catalog->patronLogin($_POST['id'], $_POST['lname']);
            if ($patron && !PEAR::isError($patron)) {
                $this->_catalog->placeHold(
                    $_GET['id'], $patron['id'], $_POST['comment'], $type
                );
            } else {
                $interface->assign('message', 'Incorrect Patron Information');
            }
        }

        $db = ConnectionManager::connectToIndex();
        $record = $db->getRecord($_GET['id']);
        if ($record) {
            $interface->assign('record', $record);
        } else {
            PEAR::raiseError(new PEAR_Error(translate('Cannot find record')));
        }

        $interface->setTemplate('hold.tpl');

        $interface->display('layout.tpl');
    }
}

?>
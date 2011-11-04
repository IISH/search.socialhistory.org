<?php
/**
 * CheckedOut action for MyResearch module
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
 * @package  Controller_MyResearch
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'services/MyResearch/MyResearch.php';

/**
 * CheckedOut action for MyResearch module
 *
 * @category VuFind
 * @package  Controller_MyResearch
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class CheckedOut extends MyResearch
{
    /**
     * Process parameters and display the page.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        global $interface;

        // Get My Transactions
        if ($patron = $this->catalogLogin()) {
            $result = $this->catalog->getMyTransactions($patron);
            if (!PEAR::isError($result)) {
                $transList = array();
                foreach ($result as $data) {
                    $record = $this->db->getRecord($data['id']);
                    $transList[] = array(
                        'id'      => $data['id'],
                        'isbn'    => $record['isbn'],
                        'author'  => $record['author'],
                        'title'   => $record['title'],
                        'format'  => $record['format'],
                        'duedate' => $data['duedate']
                    );
                }
                $interface->assign('transList', $transList);
            }
        }

        $interface->setTemplate('checkedout.tpl');
        $interface->setPageTitle('Checked Out Items');
        $interface->display('layout.tpl');
    }
}

?>
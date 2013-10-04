<?php
/**
 * Email action for Search module
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
require_once 'sys/Mailer.php';

/**
 * Email action for Search module
 *
 * @category VuFind
 * @package  Controller_Search
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class Email extends Action
{
    /**
     * Process incoming parameters and display the page.
     * We will sent two mails:
     * One to the person that ordered the poster
     * The other to the repro
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        global $interface;
        global $configArray;

        $interface->assign('orderAccess_token', $configArray['IISH']['orderAccess_token']);

        if (isset($_POST['submit'])) {

            $limit = 25;
            foreach ($_POST as $key => $value) {
                $limit--;
                $interface->assign($key, $value);
                if ($limit < 0)
                    return;
            }

            $limit = 25;
            foreach ($_POST as $key => $value) {
                $limit--;
                $interface->assign($key, $value);
                if ($limit < 0)
                    break;
            }

            // Sent to repo
            $result = $this->sendEmail('Order/ordermail.tpl', $configArray['IISH']['orderTo'], $_POST['email'], $configArray['IISH']['orderSubject'] . " " . $_POST['fullname']);
            if (PEAR::isError($result)) {
                $interface->assign('errorMsg', $result->getMessage());
                $interface->display("Order/reproduction.tpl");
                return;
            }

            // Sent to customer
            $result = $this->sendEmail('Order/ordermail.customer.tpl', $_POST['email'], $configArray['IISH']['orderFrom'], $configArray['IISH']['orderSubject']);
            if (PEAR::isError($result)) {
                $interface->assign('errorMsg', $result->getMessage());
                $interface->display("Order/reproduction.tpl");
                return;
            }

            $interface->display("Order/ordered.tpl");
        }
    }

    /**
     * Send a record email.
     *
     * @param string $subject     Subject to include in message
     * @param string $to      Message recipient address
     * @param string $from    Message sender address
     * @param string $message User-provided message to send
     *
     * @return mixed          Boolean true on success, PEAR_Error on failure.
     * @access public
     */
    public function sendEmail($tpl, $to, $from, $subject)
    {
        global $interface;

        $body = $interface->fetch($tpl);
        $mail = new VuFindMailer();
        return $mail->send($to, $from, $subject, $body);
    }
}

?>

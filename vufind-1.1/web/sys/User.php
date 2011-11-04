<?php
/**
 * Wrapper class for handling logged-in user in session.
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
 * @package  Support_Classes
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/system_classes Wiki
 */
require_once 'XML/Unserializer.php';
require_once 'XML/Serializer.php';

require_once 'sys/authn/AuthenticationFactory.php';

// This is necessary for unserialize
require_once 'services/MyResearch/lib/User.php';

/**
 * Wrapper class for handling logged-in user in session.
 *
 * @category VuFind
 * @package  Support_Classes
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/system_classes Wiki
 */
class UserAccount
{
    /**
     * Checks whether the user is logged in.
     *
     * @return bool Is the user logged in?
     * @access public
     */
    public static function isLoggedIn()
    {
        if (isset($_SESSION['userinfo'])) {
            return unserialize($_SESSION['userinfo']);
        }
        return false;
    }

    /**
     * Updates the user information in the session.
     *
     * @param object $user User object to store in the session
     *
     * @return void
     * @access public
     */
    public static function updateSession($user)
    {
        $_SESSION['userinfo'] = serialize($user);
    }

    /**
     * Try to log in the user using current query parameters; return User object
     * on success, PEAR error on failure.
     *
     * @return object
     * @access public
     */
    public static function login()
    {
        global $configArray;

        // Perform authentication:
        try {
            $authN = AuthenticationFactory::initAuthentication(
                $configArray['Authentication']['method']
            );
            $user = $authN->authenticate();
        } catch (Exception $e) {
            if ($configArray['System']['debug']) {
                echo "Exception: " . $e->getMessage();
            }
            $user = new PEAR_Error('authentication_error_technical');
        }

        // If we authenticated, store the user in the session:
        if (!PEAR::isError($user)) {
            self::updateSession($user);
        }

        // Send back the user object (which may be a PEAR error):
        return $user;
    }
}

?>

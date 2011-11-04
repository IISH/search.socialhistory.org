<?php
/**
 * Base class for building Selenium tests.
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
 * @package  Tests
 * @author   Preetha Rao <vufind-tech@lists.sourceforge.net>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/unit_tests Wiki
 */

/**
 * Set up test environment.
 */
require_once dirname(__FILE__) . '/../../web/prepend.inc.php';

/**
 * Load Selenium driver code.
 */
require_once 'Testing/Selenium.php';

/**
 * Base class for building Selenium tests.
 *
 * @category VuFind
 * @package  Tests
 * @author   Preetha Rao <vufind-tech@lists.sourceforge.net>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/unit_tests Wiki
 */
class SeleniumTestCase extends PHPUnit_Framework_TestCase
{
    protected $baseUrl;
    protected $hostname;
    protected $selenium;

    /**
     * Constructor
     *
     * @access public
     */
    public function __construct()
    {
        // Load the default configuration, but override the base path so that
        // Smarty can find the real templates and cache folders.
        $configArray = parse_ini_file(
            dirname(__FILE__) . '/../../../web/conf/config.ini', true
        );

        // Read base URL from config file:
        $this->baseUrl = $configArray['Site']['url'];

        // Extract hostname from base URL:
        preg_match('/https?:\/\/([^\/]*).*/', $this->baseUrl, $matches);
        $this->hostname = $matches[1];
    }

    /**
     * Standard setup method.
     *
     * @return void
     * @access public
     */
    public function setUp()
    {
        $this->selenium = new Testing_Selenium("*firefox", $this->baseUrl);
        $this->selenium->start();
    }

    /**
     * Standard teardown method.
     *
     * @return void
     * @access public
     */
    public function tearDown()
    {
        $this->selenium->stop();
    }
}
?>
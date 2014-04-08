<?php
/**
 * Book Cover Generator
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
 * @package  Cover_Generator
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/use_of_external_content Wiki
 */
require_once 'sys/Proxy_Request.php';
require_once 'sys/Logger.php';
require_once 'sys/ISBN.php';

// Retrieve values from configuration file
$configArray = parse_ini_file('conf/config.ini', true);
$logger = new Logger();

// global to hold filename constructed from ISBN
$localFile = '';

// Proxy server settings
if (isset($configArray['Proxy']['host'])) {
    if (isset($configArray['Proxy']['port'])) {
        $proxy_server
            = $configArray['Proxy']['host'] . ":" . $configArray['Proxy']['port'];
    } else {
        $proxy_server = $configArray['Proxy']['host'];
    }
    $proxy = array(
        'http' => array(
            'proxy' => "tcp://$proxy_server", 'request_fulluri' => true
        )
    );
    stream_context_get_default($proxy);
}

// Display a fail image unless our parameters pass inspection and we are able to
// display an ISBN or content-type-based image.
if (!sanitizeParameters()) {
    dieWithFailImage();
} else if (!fetchFromISBN($_GET['isn'], $_GET['size'])
    && !fetchFromContentType($_GET['contenttype'], $_GET['size'])
) {
    dieWithFailImage();
}

/* END OF INLINE CODE */

/**
 * Sanitize incoming parameters to avoid filesystem attacks.  We'll make sure the
 * provided size matches a whitelist, and we'll strip illegal characters from the
 * ISBN and/or contentType
 *
 * @return  bool       True if parameters ok, false on failure.
 */
function sanitizeParameters()
{
    $validSizes = array('small', 'medium', 'large');
    if (!count($_GET) || !in_array($_GET['size'], $validSizes)) {
        return false;
    }
    // sanitize ISBN
    $_GET['isn'] = isset($_GET['isn'])
        ? preg_replace('/[^0-9xX]/', '', $_GET['isn']) : '';

    if ( isset($_GET['pid'] ) )
        $_GET['isn'] = $_GET['pid'] ;

    // sanitize contenttype
    // file names correspond to Summon Content Types with spaces
    // removed, eg. VideoRecording.png
    $_GET['contenttype'] = isset($_GET['contenttype'])
        ? preg_replace("/[^a-zA-Z]/", "", $_GET['contenttype']) : '';

    return true;
}

/**
 * Load bookcover fom URL from cache or remote provider and display if possible.
 *
 * @param string $isn  ISBN (10 characters preferred)
 * @param string $size Size of cover (large, medium, small)
 *
 * @return bool        True if image displayed, false on failure.
 */
function fetchFromISBN($isn, $size)
{
    global $configArray;
    global $localFile;

    if (empty($isn)) {
        return false;
    }

    $localFile = 'images/covers/' . $size . '/' . $isn . '.jpg';
    if (is_readable($localFile)) {
        // Load local cache if available
        header('Content-type: image/jpeg');
        echo readfile($localFile);
        return true;
    } else {
        // Fetch from provider
        if (isset($configArray['Content']['coverimages'])) {
            $providers = explode(',', $configArray['Content']['coverimages']);
            foreach ($providers as $provider) {
                $provider = explode(':', $provider);
                $func = $provider[0];
                $key = isset($provider[1]) ? $provider[1] : null;
                if ($func($key)) {
                    return true;
                }
            }
        }
    }
    return false;
}

/**
 * Load content type icon image from URL from theme images and display if possible.
 *
 * @param string $type Content type names, matching filename
 * @param string $size Size of icon (large, medium, small)
 *
 * @return bool        True if image displayed, false on failure.
 */
function fetchFromContentType($type, $size)
{
    global $configArray;

    // Give up if no content type was passed in:
    if (empty($type)) {
        return false;
    }

    // Array of image formats we may want to display:
    $formats = array('png', 'gif', 'jpg');

    // Take theme inheritance into account -- iterate down the list of themes from
    // config.ini and check each one in turn for icon images:
    $themes = explode(',', $configArray['Site']['theme']);
    for ($i = 0; $i < count($themes); $i++) {
        // Check all supported image formats:
        foreach ($formats as $format) {
            // Build the potential filename:
            $iconFile = dirname(__FILE__) . '/interface/themes/' . $themes[$i] .
                '/images/' . $size . '/' . $type . '.' . $format;
            // If the file exists, display it:
            if (is_readable($iconFile)) {
                // Most content-type headers match file extensions... but include a
                // special case for jpg vs. jpeg:
                header(
                    'Content-type: image/' . ($format == 'jpg' ? 'jpeg' : $format)
                );
                echo readfile($iconFile);
                return true;
            }
        }
    }

    // If we got this far, no icon was found:
    return false;
}

/**
 * Display the user-specified "cover unavailable" graphic (or default if none
 * specified) and terminate execution.
 *
 * @return void
 * @author Thomas Schwaerzler <vufind-tech@lists.sourceforge.net>
 */
function dieWithFailImage()
{
    global $configArray, $logger;

    // Get "no cover" image from config.ini:
    $noCoverImage = isset($configArray['Content']['noCoverAvailableImage'])
        ? $configArray['Content']['noCoverAvailableImage'] : null;
    if ( $_GET['alt']) $noCoverImage = isset($configArray['Content'][$_GET['alt']])
        ? $configArray['Content']['noCoverAvailableImageEad'] : null;

    // No setting -- use default, and don't log anything:
    if (empty($noCoverImage)) {
        // log?
        dieWithDefaultFailImage();
    }

    // If file defined but does not exist, log error and display default:
    if (!file_exists($noCoverImage) || !is_readable($noCoverImage)) {
        $logger->log(
            "Cannot access file: '$noCoverImage' in directory " . dirname(__FILE__),
            PEAR_LOG_ERR
        );
        dieWithDefaultFailImage();
    }

    // Array containing map of allowed file extensions to mimetypes (to be extended)
    $allowedFileExtensions = array(
        "gif" => "image/gif",
        "jpeg" => "image/jpeg", "jpg" => "image/jpeg",
        "png" => "image/png",
        "tiff" => "image/tiff", "tif" => "image/tiff"
    );

    // Log error and bail out if file lacks a known image extension:
    $fileExtension = strtolower(end(explode('.', $noCoverImage)));
    if (!array_key_exists($fileExtension, $allowedFileExtensions)) {
        $logger->log(
            "Illegal file-extension '$fileExtension' for image '$noCoverImage'",
            PEAR_LOG_ERR
        );
        dieWithDefaultFailImage();
    }

    // Get mime type from file extension:
    $mimeType = $allowedFileExtensions[$fileExtension];

    // Display the image and die:
    header("Content-type: $mimeType");
    echo readfile($noCoverImage);
    exit();
}

/**
 * Display the default "cover unavailable" graphic and terminate execution.
 *
 * @return void
 */
function dieWithDefaultFailImage()
{
    header('Content-type: image/gif');
    echo readfile('images/noCover2.gif');
    exit();
}

/**
 * Load image from URL, store in cache if requested, display if possible.
 *
 * @param string $url   URL to load image from
 * @param string $cache Boolean -- should we store in local cache?
 *
 * @return bool         True if image displayed, false on failure.
 */
function processImageURL($url, $cache = true, $reduce = false)
{
    global $localFile; // this was initialized by fetchFromISBN()

    if ($image = @file_get_contents($url)) {
        // Figure out file paths -- $tempFile will be used to store the downloaded
        // image for analysis.  $finalFile will be used for long-term storage if
        // $cache is true or for temporary display purposes if $cache is false.
        $tempFile = str_replace('.jpg', uniqid(), $localFile);
        $finalFile = $cache ? $localFile : $tempFile . '.jpg';

        // If some services can't provide an image, they will serve a 1x1 blank
        // or give us invalid image data.  Let's analyze what came back before
        // proceeding.
        $file_put_contents = file_put_contents($tempFile, $image);
        if (!@$file_put_contents) {
            die("Unable to write to image directory.");
        }
        list($width, $height, $type) = @getimagesize($tempFile);

        // File too small -- delete it and report failure.
        if ($width < 2 && $height < 2) {
            @unlink($tempFile);
            return false;
        }

        if ( $reduce > 0 ) {
        		include('SimpleImage.php');
        		$image = new SimpleImage();
                	$image->load($tempFile);
                	$image->resizeToWidth(350);
                	$image->save($tempFile);
        	}

        // Conversion needed -- do some normalization for non-JPEG images:
        if ($type != IMAGETYPE_JPEG) {
            // We no longer need the temp file:
            @unlink($tempFile);

            // We can't proceed if we don't have image conversion functions:
            if (!is_callable('imagecreatefromstring')) {
                return false;
            }

            // Try to create a GD image and rewrite as JPEG, fail if we can't:
            if (!($imageGD = @imagecreatefromstring($image))) {
                return false;
            }
            if (!@imagejpeg($imageGD, $finalFile)) {
                return false;
            }
        } else {
            // If $tempFile is already a JPEG, let's store it in the cache.
            @rename($tempFile, $finalFile);
        }



        // Display the image:
        header('Content-type: image/jpeg');
        readfile($finalFile);

        // If we don't want to cache the image, delete it now that we're done.
        if (!$cache) {
            @unlink($finalFile);
        }

        return true;
    } else {
        return false;
    }
}

/**
 * Retrieve a Syndetics cover.
 *
 * @param string $id Syndetics client ID.
 *
 * @return bool      True if image displayed, false otherwise.
 */
function syndetics($id)
{
    global $configArray;

    switch ($_GET['size']) {
        case 'small':
            $size = 'SC.GIF';
            break;
        case 'medium':
            $size = 'MC.GIF';
            break;
        case 'large':
            $size = 'LC.JPG';
            break;
    }

    $url = isset($configArray['Syndetics']['url']) ?
        $configArray['Syndetics']['url'] : 'http://syndetics.com';
    $url .= "/index.aspx?type=xw12&isbn={$_GET['isn']}/{$size}&client={$id}";
    return processImageURL($url);
}

/**
 * Retrieve a Content Cafe cover.
 *
 * @param string $id Content Cafe client ID.
 *
 * @return bool      True if image displayed, false otherwise.
 */
function contentcafe($id)
{
    global $configArray;

    switch ($_GET['size']) {
        case 'small':
            $size = 'S';
            break;
        case 'medium':
            $size = 'M';
            break;
        case 'large':
            $size = 'L';
            break;
    }
    $pw = $configArray['Contentcafe']['pw'];
    $url = isset($configArray['Contentcafe']['url'])
        ? $configArray['Contentcafe']['url'] : 'http://contentcafe2.btol.com';
    $url .= "/ContentCafe/Jacket.aspx?UserID={$id}&Password={$pw}&Return=1" .
        "&Type={$size}&Value={$_GET['isn']}&erroroverride=1";
    return processImageURL($url);
}

/**
 * Retrieve a LibraryThing cover.
 *
 * @param string $id LibraryThing client ID.
 *
 * @return bool      True if image displayed, false otherwise.
 */
function librarything($id)
{
    $url = 'http://covers.librarything.com/devkey/' . $id . '/' . $_GET['size'] .
        '/isbn/' . $_GET['isn'];
    return processImageURL($url);
}

/**
 * Retrieve an OpenLibrary cover.
 *
 * @return bool True if image displayed, false otherwise.
 */
function openlibrary()
{
    // Convert internal size value to openlibrary equivalent:
    switch ($_GET['size']) {
        case 'large':
            $size = 'L';
            break;
        case 'medium':
            $size = 'M';
            break;
        case 'small':
        default:
            $size = 'S';
            break;
    }

    // Retrieve the image; the default=false parameter indicates that we want a 404
    // if the ISBN is not supported.
    $url = 'http://covers.openlibrary.org/b/isbn/' . $_GET['isn'] .
        "-{$size}.jpg?default=false";
    return processImageURL($url);
}

/**
 * Retrieve a Google Books cover.
 *
 * @return bool True if image displayed, false otherwise.
 */
function google()
{
    // Don't bother trying if we can't read JSON:
    if (is_callable('json_decode')) {
        // Construct the request URL:
        $url = 'http://books.google.com/books?jscmd=viewapi&' .
            'bibkeys=ISBN:' . $_GET['isn'] . '&callback=addTheCover';

        // Make the HTTP request:
        $client = new Proxy_Request();
        $client->setMethod(HTTP_REQUEST_METHOD_GET);
        $client->setURL($url);
        $result = $client->sendRequest();

        // Was the request successful?
        if (!PEAR::isError($result)) {
            // grab the response:
            $json = $client->getResponseBody();

            // extract the useful JSON from the response:
            $count = preg_match('/^[^{]*({.*})[^}]*$/', $json, $matches);
            if ($count < 1) {
                return false;
            }
            $json = $matches[1];

            // convert \x26 or \u0026 to &
            $json = str_replace(array("\\x26", "\\u0026"), "&", $json);

            // decode the object:
            $json = json_decode($json, true);

            // convert a flat object to an array -- probably unnecessary, but
            // retained just in case the response format changes:
            if (isset($json['thumbnail_url'])) {
                $json = array($json);
            }

            // find the first thumbnail URL and process it:
            foreach ($json as $current) {
                if (isset($current['thumbnail_url'])) {
                    return processImageURL($current['thumbnail_url'], false);
                }
            }
        }
    }
    return false;
}

/**
 * Retrieve an Amazon cover.
 *
 * @param string $id Amazon Web Services client ID.
 *
 * @return bool      True if image displayed, false otherwise.
 */
function amazon($id)
{
    include_once 'sys/Amazon.php';

    $params = array('ResponseGroup' => 'Images', 'ItemId' => $_GET['isn']);
    $request = new AWS_Request($id, 'ItemLookup', $params);
    $result = $request->sendRequest();
    if (!PEAR::isError($result)) {
        $data = @simplexml_load_string($result);
        if (!$data) {
            return false;
        }
        if (isset($data->Items->Item[0])) {
            // Where in the XML can we find the URL we need?
            switch ($_GET['size']) {
                case 'small':
                    $imageIndex = 'SmallImage';
                    break;
                case 'medium':
                    $imageIndex = 'MediumImage';
                    break;
                case 'large':
                    $imageIndex = 'LargeImage';
                    break;
                default:
                    $imageIndex = false;
                    break;
            }

            // Does a URL exist?
            if ($imageIndex && isset($data->Items->Item[0]->$imageIndex->URL)) {
                $imageUrl = (string)$data->Items->Item[0]->$imageIndex->URL;
                return processImageURL($imageUrl, false);
            }
        }
    }

    return false;
}

/**
 * Retrieve a Summon cover.
 *
 * @param string $id Serials Solutions client key.
 *
 * @return bool      True if image displayed, false otherwise.
 */
function summon($id)
{
    global $configArray;

    // convert normalized 10 char isn to 13 digits
    $isn = $_GET['isn'];
    if (strlen($isn) != 13) {
        $ISBN = new ISBN($isn);
        $isn = $ISBN->get13();
    }
    $url = 'http://api.summon.serialssolutions.com/image/isbn/' . $id . '/' . $isn .
        '/' . $_GET['size'];
    return processImageURL($url);
}

/**
 * Retrieve an audio\visual from the IISG.
 * The interpretation of the isb is the handle: http://hdl.handle.net/10622/[identifier]
 *
 * The images from this domain a a little too large, so we resize these
 *
 * @param string
 *
 * @return bool
 */
function iish()
{
    /*$reductionSizeInWidth = 0;
    $pid = $_GET['pid'];
    switch ($_GET['size']) {
        case 'small':
            $imageIndex = 'level3';
            break;
        case 'medium':
        case 'large':
        default:
            $imageIndex = 'level2';
		$reductionSizeInWidth = 350;
            break;
    }

    $imageUrl = "http://hdl.handle.net/10622/" . $pid . "?locatt=view:" . $imageIndex;
    processImageURL($imageUrl, true, $reductionSizeInWidth);*/
}

?>

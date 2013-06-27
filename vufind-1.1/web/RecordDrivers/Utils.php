<?php
/**
 * Utility class
 */

final class Utils
{

    public static function getResource($id, $pid, $metadataPrefix)
    {
        global $configArray;

        // First see if we have it in cache. This ought to have been done by the indexing process ( iish.bsh )
        $folder = $configArray['IISH']['cache'] . "/";
        if (!is_dir($folder)) {
            mkdir($folder);
        }
        $file = $folder . $id . ".xml";
        if ($configArray['IISH']['useCache'] && is_readable($file)) {
            return Utils::fromCache($file);
        }

        // Load from api
        $_baseURL = $configArray['IISH']['oaiBaseUrl'];

        // Transform MARCXML... taken from /harvest/harvest_oai.php
        $request = new Proxy_Request();
        $request->setMethod(HTTP_REQUEST_METHOD_GET);
        $request->setURL($_baseURL);
        $request->addQueryString('verb', 'GetRecord');
        $request->addQueryString('identifier', $pid); // the oai identifier... not  that of the solr
        $request->addQueryString('metadataPrefix', $metadataPrefix);
        $result = $request->sendRequest();
        if (PEAR::isError($result)) {
            die($result->getMessage() . "\n");
        }
        $response = $request->getResponseBody();
        // Save our XML:
        file_put_contents($file, $response);

        return Utils::fromCache($file);
    }

    private static function fromCache($file)
    {

        try {
            return @file_get_contents($file);
        } catch (Exception $e) {
        }
        return false;
    }

    public static function getTestResource($url)
    {
        /*$request = new Proxy_Request();
        $request->setMethod(HTTP_REQUEST_METHOD_GET);
        $request->setURL($url);
        $result = $request->sendRequest();
        if (PEAR::isError($result)) {
            die($result->getMessage() . "\n");
        }
        return $request->getResponseBody();*/
        $doc = new DOMDocument();
        $doc = DOMDocument::load($url);
        return $doc;
    }
}

<?php
/**
 * Utility class
 */

final class Utils
{

    public static function getOAIRecord($id, $pid, $metadataPrefix)
    {
        global $configArray;
        $file = $configArray['IISH']['cache'] . '/' . md5($id . '_' . $metadataPrefix);
        if (Utils::useCache($file)) {
            $doc = new DOMDocument();
            $doc->load($file);
            return $doc;
        }

        // Load from api
        // Transform MARCXML... taken from /harvest/harvest_oai.php
        $request = new Proxy_Request();
        $request->setMethod(HTTP_REQUEST_METHOD_GET);
        $request->setURL($configArray['IISH']['oaiBaseUrl']);
        $request->addQueryString('verb', 'GetRecord');
        $request->addQueryString('identifier', $pid); // the oai identifier... not  that of the solr
        $request->addQueryString('metadataPrefix', $metadataPrefix);
        $result = $request->sendRequest();
        if (PEAR::isError($result)) {
            PEAR::RaiseError(new PEAR_Error($result->getMessage()));
            die();
        }
        $response = $request->getResponseBody();
        file_put_contents($file, $response);
        $doc = new DOMDocument();
        $doc->load($file);
        return $doc;
    }

    private static function useCache($file)
    {
        global $configArray;
        return !isset($_GET['nocache']) && is_readable($file) &&
        $configArray['IISH']['cacheExpiration'] &&
        filectime($file) > (time() - $configArray['IISH']['cacheExpiration']);
    }
}
<?php
/**
 * Created by IntelliJ IDEA.
 * User: lwo
 * Date: 7/3/11
 * Time: 3:26 PM
 * To change this template use File | Settings | File Templates.
 */
 
final class Utils {

    public static function getResource($id, $metadataPrefix)
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
        $request->addQueryString('identifier', $id);
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
}

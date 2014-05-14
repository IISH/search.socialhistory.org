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

    public static function accessToken($separator = '&')
    {

        global $configArray;
        if (isset($configArray['IISH']['audience_internal'])) {
            $client_ip = $_SERVER['REMOTE_ADDR'];
            $networks = explode(',', $configArray['IISH']['audience_internal']);

            foreach ($networks as $network) {
                if (Utils::netMatch($network, $client_ip)) {
                    return $separator . 'urlappend=%3Faccess_token%3D' . $configArray['IISH']['anonymousAccess_token'];
                }
            }
        }

        return null;
    }

    public static function netMatch($network, $ip)
    {

        $network = trim($network);
        $ip = trim($ip);
        if ($ip == $network) {
            echo "used network ($network) for ($ip)\n";
            return TRUE;
        }
        $network = str_replace(' ', '', $network);
        if (strpos($network, '*') !== FALSE) {
            if (strpos($network, '/') !== FALSE) {
                $asParts = explode('/', $network);
                $network = @ $asParts[0];
            }
            $nCount = substr_count($network, '*');
            $network = str_replace('*', '0', $network);
            if ($nCount == 1) {
                $network .= '/24';
            } else if ($nCount == 2) {
                $network .= '/16';
            } else if ($nCount == 3) {
                $network .= '/8';
            } else if ($nCount > 3) {
                return TRUE; // if *.*.*.*, then all, so matched
            }
        }

        #echo "from original network($orig_network), used network ($network) for ($ip)\n";

        $d = strpos($network, '-');
        if ($d === FALSE) {
            $ip_arr = explode('/', $network);
            if (!preg_match('@\d*\.\d*\.\d*\.\d*@', $ip_arr[0], $matches)) {
                $ip_arr[0] .= ".0"; // Alternate form 194.1.4/24
            }
            $network_long = ip2long($ip_arr[0]);
            $x = ip2long($ip_arr[1]);
            $mask = long2ip($x) == $ip_arr[1] ? $x : (0xffffffff << (32 - $ip_arr[1]));
            $ip_long = ip2long($ip);
            return ($ip_long & $mask) == ($network_long & $mask);
        } else {
            $from = trim(ip2long(substr($network, 0, $d)));
            $to = trim(ip2long(substr($network, $d + 1)));
            $ip = ip2long($ip);
            return ($ip >= $from and $ip <= $to);
        }
    }
}
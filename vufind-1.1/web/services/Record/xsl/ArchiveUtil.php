<?php
/**
 * Class Lang
 *
 * Accepts a map of keys and values
 *
 */

require_once 'RecordDrivers/Utils.php';

class ArchiveUtil
{

    private static $dictionary = array();


    public static function generateID($key, $tag)
    {
        $t = ( $tag ) ? $tag[0]->nodeValue : ""  ;
        return 'A' . substr(md5($key . ':' . $t . '          '), 0, 10);
    }

    public static function truncate($text, $limit = 300){

        $separators = " -:;," ;
        $length = strlen($text);

        if ( $length < $limit) return $text;
        for ( $i = $limit; $i < $length; $i++) {
            if ( strrpos($separators, $text[$i]) !== false ){
                return substr($text, 0, $i)  ;
            }
        }
        return $text;
    }

    public static function translate($lang, $key)
    {
        if (empty(ArchiveUtil::$dictionary)) {
            ArchiveUtil::load($lang);
        }
        $ret = ArchiveUtil::$dictionary[$key];
        if ($ret == null) return $key;
        return $ret;
    }

    private static function load($lang)
    {
        global $configArray;
        $file = $configArray['Site']['local'] . '/lang/' . $lang . '.ini';

        $handle = @fopen($file, "r");
        if ($handle) {
            while (($buffer = fgets($handle, 4096)) !== false) {
                $pos = strrpos($buffer, '=');
                if ($pos > 1) {
                    $key = trim(substr($buffer, 0, $pos));
                    $value = trim(substr($buffer, $pos + 1));
                    if (!empty($value)) ArchiveUtil::$dictionary[$key] = $value;
                }
            }
        }
        if (!feof($handle)) {
            echo "Error: unexpected fgets() fail\n";
        }
        fclose($handle);
    }
}

?>


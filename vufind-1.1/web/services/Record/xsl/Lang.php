<?php
/**
 * Class Lang
 *
 * Accepts a map of keys and values
 *
 */

require_once 'RecordDrivers/Utils.php';

class Lang
{

    private static $dictionary = array();


    public static function generateID($key, $tag)
    {
        return 'A' . substr(md5($key . ':' . $tag . '          '), 0, 10);
    }

    public static function translate($lang, $key)
    {
        if (empty(Lang::$dictionary)) {
            Lang::load($lang);
        }
        $ret = Lang::$dictionary[$key];
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
                    if (!empty($value)) Lang::$dictionary[$key] = $value;
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


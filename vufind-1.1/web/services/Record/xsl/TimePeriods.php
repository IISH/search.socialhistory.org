<?php

class TimePeriods
{
    public static function getDates($info, $text)
    {
        $normalized = preg_replace("(\s|\t|\r|\n|\(|\)|\[|\]|\\\)", "", $text);
        $periods = array();
        preg_match_all("(\d{4}-\d{4}|\d{4})", $normalized, $periods);
        $count = count($periods);
        if ( $count == 0 )
            return null;
        $count = count($periods[0]);
        $ret = "";
        for ($i = 0; $i < $count; $i++)
        {
            $period = $periods[0][$i];
            $from = substr($period, 0, 4);
            $to = (strlen($period) == 4)
                    ? $period
                    : substr($period, 5);
            $ret = $ret . "{" . $info . ",from:" . $from . ",to:" . $to . "}";
            if ($i < $count - 1 )
                $ret = $ret . ",";
        }
        return $ret;
    }
}

//$dates = TimePeriods::getDates("hello","2010, 1872-1899");
//echo $dates;

?>
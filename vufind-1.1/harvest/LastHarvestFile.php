<?php
/**
 * LastHarvestFile
 *
 * Usage: LastHarvestFile date[example yyyy-mm-dd] offset[example -3 day] file[e                                                                                                                      xample last_harvest.txt]
 */

if (sizeof($argv) != 4) {
    die("Could not load settings for date, time offset and filename.\n");
}

$date = $argv[1];
$offset = $argv[2];
$_lastHarvestFile = $argv[3];

$newdate = strtotime($offset, strtotime($date));
$newdate = date('Y-m-d', $newdate);

echo $newdate;
file_put_contents($_lastHarvestFile, $newdate);

?>


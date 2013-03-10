#!/bin/bash
b=https://bamboo.socialhistoryservices.org/browse/SEARCH-SEARCH/latestSuccessful/artifact/JOB1/import-1.0.jar/import-1.0.jar
wget --no-check-certificate -O /usr/bin/vufind/import-1.0.jar $b

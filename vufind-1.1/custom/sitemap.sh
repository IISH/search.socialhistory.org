#!/bin/bash

source /usr/local/vufind/custom/setup.sh

##############################################################################
# Build the sitemap

service tomcat6 start
sleep 5

php /usr/local/vufind/util/sitemap.php
chown -R root:www-data /data/caching/sitemap
chmod -R 754 /data/caching/sitemap

service tomcat6 stop

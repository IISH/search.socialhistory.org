#!/bin/bash

source /usr/local/vufind/custom/config.sh

##############################################################################
# Build the sitemap

#service tomcat6 start
#sleep 5

php /usr/local/vufind/util/sitemap.php
chown -R root:www-data /data/cache/sitemap
chmod -R 754 /data/cache/sitemap

#service tomcat6 stop

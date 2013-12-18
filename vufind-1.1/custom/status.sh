#!/bin/bash

c=$1
if [ -z "$c" ] ; then
	c="status"
fi

restart=/usr/local/vufind/solr/restart.txt
if [ $c == "restart" ] ; then
	if [ -f $restart ] ; then
		service tomcat6 stop
		service tomcat6 start
		rm $restart
	fi
	exit 0
fi


if [ -f $restart ] ; then
	exit 0
fi


q="http://127.0.0.1/Search/Results?lookfor=apple"
O=/tmp/status.txt
wget --spider -T 3 -t 3 -O $O $q
rc=$?
if [[ $rc != 0 ]] ; then
	echo "Invalid response at $(date)" >> /opt/status.txt
	service tomcat6 stop
	service apache2 stop
	sleep 5
	killall java
	mount -a
	sleep 5
	service tomcat6 start
	service apache2 start
fi

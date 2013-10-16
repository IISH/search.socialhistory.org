#!/bin/bash

q="http://127.0.0.1/Search/Results?lookfor=apple"
O=/tmp/status.txt
wget -T 3 -t 3 -O $O $q
rc=$?
if [[ $rc != 0 ]] ; then
	echo "Invalid response at $(date)" >> /opt/status.txt
	service tomcat6 stop
	service apache2 stop
	sleep 5
	killall java
	sleep 5
	service tomcat6 start
	service apache2 start
fi

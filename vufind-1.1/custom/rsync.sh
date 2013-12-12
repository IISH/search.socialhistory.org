#!/bin/bash

# Solr support replication. But the download time from the be0 and be1 can take rather long time and thus fail.
# This script is therefor a workaround. It is run from the store0 node

# If no parameter was given, we replicate the master index
if [ "$1" == "" ];
then
	index0=/data/search.socialhistory.org.index0/vufind-1.1/solr/
else
	index0=$1
fi


for i in {0..3}
	do
		base=/data/search.socialhistory.org.be"$i"
		be=$base/vufind-1.1/solr/
		mkdir -p $be
		rsync --delete -avv $index0 $be
		chown -R tomcat6:tomcat6 $base
		#url=http://erebus.be"$i".iisg.net:8080/solr/admin/multicore?action="RELOAD&core=biblio"
		#wget -O /tmp/reload.txt "$url"
		#url=http://erebus.be"$i".iisg.net:8080/solr/admin/multicore?action="RELOAD&core=authority"
		#wget -O /tmp/reload.txt "$url"
done
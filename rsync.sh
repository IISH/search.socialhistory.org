#!/bin/bash

# Solr support replication. But the download time from the be0 and be1 can take rather long time and thus fail.
# This script is therefor a workaround. It is run from the store0 node

index0=/data/search.socialhistory.org.index0/vufind-1.1/solr/


for i in {0..1}
	do
		be=/data/search.socialhistory.org.be"$i"/vufind-1.1/solr/
		rsync --delete -avv $index0 $be
		chown -R tomcat6:tomcat6 $be
		wget -O /tmp/reload.txt http://erebus.be"$i".iisg.net:8080/solr/admin/multicore?action="RELOAD&core=biblio"
		wget -O /tmp/reload.txt http://erebus.be"$i".iisg.net:8080/solr/admin/multicore?action="RELOAD&core=authority"
done


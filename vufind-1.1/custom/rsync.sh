#!/bin/bash

# Solr support replication. But the download time from the be0 and be1 can take rather long time and thus fail.
# This script is therefor a workaround. It is run from the store0 node

# If no parameter was given, we replicate the master index

if [ "$1" == "" ];
then
	source=/data/erebus.index0/
else
	source=$1
fi

for i in {0..3}
	do
		h=erebus.be"$i"
		target=/data/$h
		tmp=/data/tmp
		solr=$tmp/vufind-1.1/solr
		rsync --exclude '.git' --delete -avv $source $tmp
		if [ ! -d $solr/biblio ] ; then
			echo "No index replicated."
			exit -1
		fi
		chown -R tomcat6:root $solr
		chmod -R 744 $solr

		wget -O /tmp/unload.txt "http://$h.iisg.net:8080/solr/admin/multicore?action=UNLOAD&core=biblio"
		wget -O /tmp/unload.txt "http://$h.iisg.net:8080/solr/admin/multicore?action=UNLOAD&core=authority"
		rm -r $target
		mv $tmp $target
done

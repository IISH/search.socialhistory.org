#!/bin/bash
#
# rsync.sh
#
# usage: rsync.sh [/path/to/source_index]
#
# Solr support replication. But it may be the case a quick replication of all indexes is needed.


source /usr/local/vufind/custom/config.sh

source_index=$1
if [ -z "$source_index" ] ; then
    echo "Need the full source path to the solr folder to rsync from."
    exit 1
fi

i=$((${#source_index}-1))
last=${str:$i:1}
if [[ "$last" == "/" ]] ; then
    echo "Last character in the foldername should not end with a /"
    exit 1
fi

if [ ! -d $source_index ] ; then
    echo "Cannot find $source_index"
    exit 1
fi

for target in $SHARE/solr/*
do
    if [[ "$source_index" == "$target" ]] ; then
        echo "Ignore"
    else
	    echo "Processing $target"
	    echo "maintenance" > /opt/tomcat_command.txt
	    rsync --delete -av $source_index $target
	    echo "start" > /opt/tomcat_command.txt
    fi
done

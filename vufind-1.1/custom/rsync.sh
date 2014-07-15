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
    echo "Need the source index to rsync from."
    exit 1
fi

if [ ! -d $source_index ] ; then
    echo "Cannot find $source_index"
    exit 1
fi

for target in $SHARE/solr/*/
do
    if [[ "$source_index" == "$target" ]] ; then
        echo "Ignore"
    else
	    echo "Processing $f"
	    rsync --delete -av $source_index $target
    fi
done

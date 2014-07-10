#!/bin/bash

# Solr support replication. But the download time from the be0 and be1 can take rather long time and thus fail.
# This script is therefor a workaround. It is run from the store0 node

# If no parameter was given, we replicate the master index

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

for target in ${share_folder}solr/*/
do
    if [[ "$source_index" == "$target" ]] ; then
        echo "Ignore"
    else
	    echo "Processing $f"
	    rsync --delete -av $source_index $target
    fi
done

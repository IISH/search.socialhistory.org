#!/bin/bash
#
# build.sh
#
# Creates a tar file.
#
# Usage: build.sh instance version
#
# Example:
# $ build.sh search 1.0
# creates target/search-1.0.tar.gz

instance=$1
if [ -z "$instance" ] ; then
    echo "Need the instance name. E.g. 'search'"
    exit -1
fi

bamboo_tag_version=$2
if [ -z "$bamboo_tag_version" ] ; then
    echo "Need the instance name. E.g. '1.0'"
    exit -1
fi

mkdir target
archive="target/${instance}-${bamboo_tag_version}.tar.gz"
rm $archive
tar -zcaf $archive vufind-1.1

if [ -f $archive ] ; then
    exit 0
else
    echo "Failed to build a package: $archive"
    exit -1
fi



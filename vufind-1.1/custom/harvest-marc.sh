#!/bin/bash

source /usr/local/vufind/custom/config.sh

#############################################################################
# THe application path
cd $VUFIND_HOME/harvest

setSpec=$1
d=$2 
dir=$SHARE/datasets/$setSpec
now=$(date +"%Y-%m-%d")
log=$SHARE/log/$setSpec.$now.log
echo "Start job $setSpec" > $log

if [ -z "$setSpec" ] ; then
	echo "No setSpec given as argument." >> $SHARE/log/error.$now.txt 
	exit -1
fi

find $dir -type d -mtime 3 -exec rm -rf {} +
if [ -d $dir ] ; then
	echo "Folder $dir exists... skipping..." >> $log
	exit -1
fi

    echo "Clearing files" >> $log
    rm -rf $dir
    mkdir -p $dir

h=$dir/last_harvest.txt
if [ ! -z "$d" ] ; then
    echo "Adding harvest datestamp from $d" >> $log
    php $VUFIND_HOME/harvest/LastHarvestFile.php "$now" "$d" $h
    setSpec=`basename $dir`
fi

    cd $VUFIND_HOME/harvest
    echo "Begin harvest" >> $log
    rm $setSpec
    ln -s $dir $setSpec
    php harvest_oai.php $setSpec >> $log
        rm $setSpec
    f=$dir/catalog.xml
        rm $f
        rm $h
    cd $VUFIND_HOME/import
    echo "Begin import into solr" >> $log

        ./import-marc.sh -p import_$setSpec.properties $f

    if [ -f solrmarc.log.1 ] ; then
        cat solrmarc.log.1 >> $log
    fi

    if [ -f solrmarc.log ] ; then
        cat solrmarc.log >> $log
    fi

    rm solrmarc.lo*

    echo "Clearing files" >> $log
    rm -rf $dir

    echo "Creating PDF documents" >> $log
    ./fop-$setSpec.sh

##############################################################################
# Cache permissions
chown www-data $SHARE/cache/xml/*

wget -O /tmp/commit.txt "http://localhost:8080/solr/biblio/update?commit=true"

##############################################################################
# I think we are done for today...
echo "I think we are done for today..." >> $log


exit 0

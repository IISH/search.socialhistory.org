#!/bin/bash

source /usr/local/vufind/custom/setup.sh

#############################################################################
# THe application path needs to be here:
#
# We shall set the harvest date to a reasonable three day range
cd $VUFIND_HOME/harvest

setSpec=$1
d=$2 
dir=/data/datasets/$setSpec
now=$(date +"%Y-%m-%d")
log=/data/log/$setSpec.$now.log
echo "Start job $setSpec" > $log

if [ -z "$setSpec" ] ; then
	echo "No setSpec given as argument." >> /data/log/error.$now.txt 
	exit -1
fi

find $dir -type d -mtime 3 -exec rm -rf {} +
if [ -d $dir ] ; then
	echo "Folder $dir exists... skipping..." >> $log
	exit -1
fi

    mkdir -p $dir

h=$dir/last_harvest.txt
if [ ! -z "$d" ] ; then 
    echo "Adding harvest datestamp from $d" >> $log
    php $VUFIND_HOME/harvest/LastHarvestFile.php "$now" "$d" $h
    setSpec=`basename $dir`
fi

    cd $VUFIND_HOME/harvest
    echo "Begin harvest" >> $log
    php harvest_oai.php $setSpec >> $log
    f=$dir/add.xml
	rm $f
	rm $h
    java -Dxsl=marc -cp $app org.socialhistoryservices.solr.importer.Collate $dir $f
    cd $VUFIND_HOME/import
    echo "Begin import into solr" >> $log

        ./import-marc.sh -p import_$setSpec.properties $f
        echo "Delete records" >> $log
        java -Dxsl=deleted -cp $app org.socialhistoryservices.solr.importer.Collate $dir $f.delete
	while read line; do
                if [ ${#line} -gt 5 ] && [ ${#line} -lt 100 ]; then
                        wget -O /tmp/deletion.txt "http://localhost:8080/solr/biblio/update?stream.body=%3Cdelete%3E%3Cquery%3Epid%3A%22$line%22%3C%2Fquery%3E%3C%2Fdelete%3E"
                fi
	done < $f.delete

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
chown www-data /data/caching/xml/*

wget -O /tmp/commit.txt "http://localhost:8080/solr/biblio/update?commit=true"

##############################################################################
# I think we are done for today...
echo "I think we are done for today..." >> $log


exit 0

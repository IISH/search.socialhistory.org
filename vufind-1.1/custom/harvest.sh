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
    echo "Collating files into $f" >> $log
    java -Dxsl=marc -cp $app org.socialhistoryservices.solr.importer.Collate $dir $f
    cd $VUFIND_HOME/import
    echo "Begin import into solr" >> $log

    if [ "$setSpec" == "iish.evergreen.authorities" ] ; then
        ./import-marc-auth.sh $f import_auth.properties
    else
        ./import-marc.sh -p import_$setSpec.properties $f
        echo "Delete records" >> $log
        java -Dxsl=deleted -cp $app org.socialhistoryservices.solr.importer.Collate $dir $f.delete
        service tomcat6 start
        sleep 5
	while read line; do
                if [ ${#line} -gt 5 ] && [ ${#line} -lt 100 ]; then
                        wget -O /tmp/deletion.txt "http://localhost:8080/solr/biblio/update?stream.body=%3Cdelete%3E%3Cquery%3Epid%3A%22$line%22%3C%2Fquery%3E%3C%2Fdelete%3E"
                fi
	done < $f.delete
        service tomcat6 stop
        sleep 5
    fi

    cat solrmarc.log.1 >> $log
    cat solrmarc.log >> $log
	rm solrmarc.lo*

    echo "Clearing files"
    rm -rf $dir

    echo "Creating PDF documents"
    ./fop-$setSpec.sh >> $log


##############################################################################
# Update authority browse index
#

if [ "$setSpec" == "iish.evergreen.authorities" ] ; then
	alphabetical_browse=$VUFIND_HOME/solr/alphabetical_browse
	tmp=$alphabetical_browse.tmp
	rm -r $tmp
	mv $alphabetical_browse $tmp
	mkdir $$alphabetical_browse
	./index-alphabetic-browse.sh
	rc=$?
	if [[ $rc != 0 ]]; then
    		echo "Problem when indexing authorities $$alphabetical_browse" >> $log
	    	rm -r $alphabetical_browse
    		mv $tmp $alphabetical_browse
	else
    		rm -r $tmp
	fi
fi


##############################################################################
# Cache permissions
chown www-data /data/caching/xml/*


##############################################################################
# I think we are done for today...
echo "I think we are done for today..." >> $log


exit 0

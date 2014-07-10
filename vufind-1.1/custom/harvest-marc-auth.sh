#!/bin/bash

source /usr/local/vufind/custom/config.sh

#############################################################################
# THe application path needs to be here:
#
# We shall set the harvest date to a reasonable three day range
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
    java -Dxsl=marc -cp $APP org.socialhistoryservices.solr.importer.Collate $dir $f
    cd $VUFIND_HOME/import
    echo "Begin import into solr" >> $log

    ./import-marc-auth.sh $f

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

##############################################################################
# I think we are done for today...
echo "I think we are done for today..." >> $log


exit 0

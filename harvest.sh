#!/bin/bash

# Harvest driver scripts

  export VUFIND_HOME=/data/search.socialhistory.org.index0/vufind-1.1
  export SOLR_HOME=$VUFIND_HOME/solr
  export JAVA_HOME=/usr/lib/jvm/default-java
  app=/usr/bin/vufind/import-1.0.jar


#############################################################################
# THe application path needs to be here:
#
# We shall set the harvest date to a reasonable three day range
cd $VUFIND_HOME/harvest

d=$1
if [ "$d" == "" ] ; then
        d="-5 day"
fi
now=$(date +"%Y-%m-%d")
for dir in /data/datasets/*/
do
        echo "Clearing old files"
        rm -r "$dir"20*

        echo "Adding harvest datestamp"
        php $VUFIND_HOME/harvest/LastHarvestFile.php "$now" "$d" "$dir"last_harvest.txt
        setSpec=`basename $dir`
        if [ "$setSpec" == "iish.evergreen.authorities" ] ; then
                rm "$dir"last_harvest.txt
        fi
        echo Set setSpec to $setSpec    
        cd $VUFIND_HOME/harvest
        echo "Begin harvest"
        php harvest_oai.php $setSpec >> /data/log/$setSpec.$now.harvest.log
        f=/data/datasets/$setSpec.xml
        echo "Collating files into $f"
        java -Dxsl=marc -cp $app org.socialhistoryservices.solr.importer.Collate $dir $f
        cd $VUFIND_HOME/import
        echo "Begin import into solr"
        mv solrmarc.log /data/log/solrmarc.$now.log
        mv solrmarc.log.1 /data/log/solrmarc.$now.log.1

        if [ "$setSpec" == "iish.evergreen.authorities" ] ; then
                ./import-marc-auth.sh $f import_auth.properties
        else
		service tomcat6 stop
		killall java
		service tomcat6 start
		sleep 15
                ./import-marc.sh -p import_$setSpec.properties $f
                echo "Delete records"
                java -Dxsl=deleted -cp $app org.socialhistoryservices.solr.importer.Collate $dir $f.delete
                while read line; do
                if [ ${#line} -gt 5 ] ; then
                        wget -O /tmp/deletion.txt http://localhost:8080/solr/biblio/update?stream.body=%3Cdelete%3E%3Cquery%3Epid%3A%22$line%22%3C%2Fquery%3E%3C%2Fdelete%3E
                fi
                done < $f.delete

		service tomcat6 stop
		killall java
        fi

	echo "Clearing files"
        rm -r "$dir"20*

        echo "Creating PDF documents"   
        ./fop-$setSpec.sh
done


##############################################################################
# Optimize... this ought to trigger the replica's
# Yes two times,,,,  sometimes the old index files are not cleared.
service tomcat6 stop
killall java
service tomcat6 start
sleep 15
wget -O /tmp/optimize.txt http://localhost:8080/solr/biblio/update?optimize=true
wget -O /tmp/optimize.txt http://localhost:8080/solr/biblio/update?optimize=true

##############################################################################
# Update authority browse index
#
# Should the alphabetic browse fail, we have no longer that database functionality. But it is better to have no index, than a corrupt one.
wget -O /tmp/optimize.txt http://localhost:8080/solr/authority/update?optimize=true
wget -O /tmp/optimize.txt http://localhost:8080/solr/authority/update?optimize=true
service tomcat6 stop
./index-alphabetic-browse.sh


##############################################################################
# Build the sitemap
php $VUFIND_HOME/util/sitemap.php
chown -R root:www-data /data/caching/sitemap
chmod -R 754 /data/caching/sitemap


##############################################################################
# I think we are done for today...
echo I think we are done for today...


exit 0

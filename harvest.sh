# Harvest

if ( "$VUFIND_HOME" = "" );
then
  echo "Error... VUFIND home directory must be defined."
  export VUFIND_HOME=/data/search.socialhistory.org/vufind-1.1
  echo "Using default: ${VUFIND_HOME}"
  export SOLR_HOME=$VUFIND_HOME/solr
fi

app=/home/maven/repo/org/socialhistory/solr/import/1.0/import-1.0.jar

#############################################################################
# THe application path needs to be here:
cd $VUFIND_HOME/harvest
php harvest_oai.php

#############################################################################
# Now collate our material
# First the EAD
d=/data/datasets/iish.archieven/
f=/data/datasets/iish.archieven.xml
rm $f
app=/home/maven/repo/org/socialhistory/solr/import/1.0/import-1.0.jar
java -cp $app org.socialhistoryservices.solr.importer.Collate $d $f
rm -R $d*

# Import the EAD records into vufind's index
# For this we will temporarily need to write in the cache
# T orarily need to write in the cache
cd $VUFIND_HOME/import 
./import-marc.sh -p import_ead.properties $f

# And create PDF's
./fop-ead.sh

# Now update the rights
chown -R www-data:root /data/caching/ead.*
chmod 774 /data/caching/ead.*

#############################################################################
# And now for the eci...
d=/data/datasets/iish.eci/
f=/data/datasets/iish.eci.xml
rm $f
app=/home/maven/repo/org/socialhistory/solr/import/1.0/import-1.0.jar
java -cp $app org.socialhistoryservices.solr.importer.Collate $d $f
rm -R $d*

cd $VUFIND_HOME/import
./import-marc.sh -p import_eci.properties $f

#############################################################################
# Now the evergreen data
d=/data/datasets/iish.evergreen.biblio/
f=/data/datasets/iish.evergreen.biblio.xml
rm $f
java -cp $app org.socialhistoryservices.solr.importer.Collate $d $f
rm -R $d*

# Import the marc records into Evergreen
cd $VUFIND_HOME/import
./import-marc.sh $f

##############################################################################
# Update authority browse index
./index-alphabetic-browse.sh
cp -r -f ../solr/alphabetical_browse /data/search.socialhistory.org.be0/vufind-1.1/solr/.
chown -R tomcat6 /data/search.socialhistory.org.be0/vufind-1.1/solr/
cp -r -f ../solr/alphabetical_browse /data/search.socialhistory.org.be1/vufind-1.1/solr/.
chown -R tomcat6 /data/search.socialhistory.org.be1/vufind-1.1/solr/

##############################################################################
# Build the sitemap
php $VUFIND_HOME/util/sitemap.php
chown -R root:www-data /data/caching/sitemap
chmod -R 754 /data/caching/sitemap 
##############################################################################
# I think we are done for today...
echo I think we are done for today...

exit 0

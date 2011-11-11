# Harvest
export VUFIND_HOME=/data/harvester/search.socialhistory.org/vufind-1.1/
cd  $VUFIND_HOME/harvest
php harvest_oai.php

# Not collate our material
d=/data/datasets/iish.evergreen.biblio/
f=/data/datasets/iish.evergreen.biblio.xml
rm $f

# We import all records.
# To limit this, we can add a sliding time
# This would get all the records of the last 24 hours
# $ java -jar /usr/bin/collate_marc.jar $d $f 86400
app=/home/maven/repo/org/socialhistory/solr/import/1.0/import-1.0.jar
java -cp $app org.socialhistoryservices.solr.importer.Collate $d $f

# Then upload
# For this we need stylesheets to normalize the marc documents into our model
java -cp $app org.socialhistoryservices.solr/importer.DirtyImporter $f "http://localhost:8080/solr/all/update" "/data/solr-mappings.index0/solr/all/conf/normalize/iish.evergreen.biblio.xsl,/data/solr-mappings.index0/solr/all/conf/import/add.xsl,/data/solr-mappings.index0/solr/all/conf/import/addSolrDocument.xsl" "collectionName:iish.evergreen.biblio"

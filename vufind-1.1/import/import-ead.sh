
d=$VUFIND_HOME/harvest/iish.archieven.1
f=/mnt/solr/harvest/iish.archieven.1.xml
rm $f
java -jar $VUFIND_HOME/import/collate_marc.jar $d $f
$VUFIND_HOME/import/import-marc.sh -p import_ead.properties $f

$VUFIND_HOME/import/fop-ead.sh

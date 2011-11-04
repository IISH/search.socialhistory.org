
d=$VUFIND_HOME/harvest/iish.evergreen.1
f=/mnt/solr/harvest/iish.evergreen.1.xml
java -jar $VUFIND_HOME/import/collate_marc.jar $d $f
$VUFIND_HOME/import/import-marc.sh $f

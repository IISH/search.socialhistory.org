#!/bin/sh
# Load all of the .jar files in the lib directory into the classpath

source /usr/local/vufind/custom/config.sh

folder=$VUFIND_HOME/cache/xml
target=$VUFIND_HOME/cache/pdf
for file in ${folder}/* ; do
    pdf=$target/$(basename $file .xml).pdf
    echo "Creating $pdf from $file"
    fop -c $VUFIND_HOME/import/fop/fop.xconf -xml $file -xsl $VUFIND_HOME/import/xsl/ead_complete_fo.xsl -pdf $pdf -param path $VUFIND_HOME/import/xsl -param sysYear $(date +'%Y')
    if [ -f "$pdf" ] ; then
	    chown www-data "$pdf"
    fi
done

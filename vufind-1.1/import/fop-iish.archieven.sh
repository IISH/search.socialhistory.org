#!/bin/sh

# Load all of the .jar files in the lib directory into the classpath
folder=$VUFIND_HOME/caching
target=$VUFIND_HOME/caching/ead.pdf
for file in ${folder}/* ; do
    pdf=$(basename $file .xml).pdf
    echo "Creating $pdf from $file"
    fop -c $VUFIND_HOME/import/fop/fop.xconf -xml $file -xsl $VUFIND_HOME/import/xsl/ead_complete_fo.xsl -pdf $target/$pdf -param path $VUFIND_HOME/import/xsl -param sysYear $(date +'%Y')
done

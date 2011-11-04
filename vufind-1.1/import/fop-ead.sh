:wq#!/bin/sh

# Load all of the .jar files in the lib directory into the classpath
for file in ${VUFIND_CACHE}*.xml ; do
    pdf=$(basename $file .xml).pdf
    fop -xml $file -xsl $VUFIND_HOME/import/xsl/ead_complete_fo.xsl -pdf $VUFIND_CACHE$pdf
done


:wq#!/bin/sh

# Load all of the .jar files in the lib directory into the classpath
folder=$VUFIND_HOME/cache/ead.xml/10622
target=$VUFIND_HOME/cache/ead.pdf/10622
for file in ${folder}/*.xml ; do
    pdf=$(basename $file .xml).pdf
    fop -xml $file -xsl $VUFIND_HOME/import/xsl/ead_complete_fo.xsl -pdf $target/$pdf -param path $VUFIND_HOME/import/xsl
done


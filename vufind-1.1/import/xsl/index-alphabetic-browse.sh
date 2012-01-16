#!/bin/bash

set -e
set -x

cd "$VUFIND_HOME/import"

bib_index="../solr/biblio/index"
auth_index="../solr/authority/index"
index_dir="../solr/alphabetical_browse"

mkdir -p "$index_dir"

function build_browse
{
    browse=$1
    field=$2
    skip_authority=$3

    if [ "$4" != "" ]; then
        bib_leech="-Dbibleech=$4"
    else
        bib_leech=""
    fi

    if [ "$skip_authority" = "1" ]; then
        java ${bib_leech} -Dfile.encoding="UTF-8" -Dfield.preferred=heading -Dfield.insteadof=use_for -cp browse-indexing.jar PrintBrowseHeadings "$bib_index" "$field" "${browse}.tmp"
    else
        java ${bib_leech} -Dfile.encoding="UTF-8" -Dfield.preferred=heading -Dfield.insteadof=use_for -cp browse-indexing.jar PrintBrowseHeadings "$bib_index" "$field" "$auth_index" "${browse}.tmp"
    fi

    sort -T /var/tmp -u --field-separator=$'\1' -k1 "${browse}.tmp" -o "sorted-${browse}.tmp"
    java -Dfile.encoding="UTF-8" -cp browse-indexing.jar CreateBrowseSQLite "sorted-${browse}.tmp" "${browse}_browse.db"

    rm -f *.tmp

    mv "${browse}_browse.db" "$index_dir/${browse}_browse.db-updated"
    touch "$index_dir/${browse}_browse.db-ready"
}

build_browse "title" "title_fullStr" 1 VuFindTitleLeech
build_browse "topic" "topic_browse"
build_browse "author" "author_browse"

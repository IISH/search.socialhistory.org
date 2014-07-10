#!/bin/bash

source /usr/local/vufind/custom/config.sh

find /$SHARE/cache/large    -name '*.jpg' -delete
find /$SHARE/cache/medium   -name '*.jpg' -delete
find /$SHARE/cache/small    -name '*.jpg' -delete
rm /$SHARE/cache/xml/*

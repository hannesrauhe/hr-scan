#!/bin/bash
FOLDER=~/scans/$(date -I)
PDF_FILE=$(date --iso-8601=seconds).pdf
DEVICE=canon_dr:libusb:002:004

mkdir -p $FOLDER
cd $FOLDER
scanadf -d $DEVICE -N --resolution 200 --source "ADF Duplex"
if [ ! -f image-0001 ] ; then exit 0; fi
convert image* -adjoin $PDF_FILE
rm image*

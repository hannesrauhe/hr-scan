#!/bin/bash

$CONFIG_FILE=~/.hrscan/config.sh

if [ ! -f $CONFIG_FILE ] ; then
  echo "Config file $CONFIG_FILE does not exist. Run setup.sh to create it." 
  exit 1; 
fi

set -e
source $CONFIG_FILE
set +e

mkdir -p $FOLDER
cd $FOLDER
scanadf -d ${DEVICE} -N --resolution ${RESOLUTION} --source "ADF Duplex"
if [ ! -f image-0001 ] ; then 
    exit 0; 
fi
convert image* -adjoin $PDF_FILE
rm image*
if [ -n "{$WEBDAV_URL}" ] ; then
  echo "Uploading $PDF_FILE to $WEBDAV_URL"
  curl -T $PDF_FILE -u $WEBDAV_USER_PASS $WEBDAV_URL
fi
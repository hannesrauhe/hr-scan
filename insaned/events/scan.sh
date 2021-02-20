#!/bin/bash

CONFIG_FILE=/etc/insaned/events/config
DEVICE=${DEVICE-${1}}
if [ -z "$FOLDER" ] ; then
  FOLDER=$(mktemp -d --suffix=.scan)
fi
FILE_TO_UPLOAD=$(date +%Y%m%d_%H%M%S).pdf

set -e
source "${CONFIG_FILE}"
set +e

cd "$FOLDER"
if [ -n "${SCAN_IMAGE}" ] ; then
  FILE_TO_UPLOAD=$(date +%Y%m%d_%H%M%S).jpg
  scanimage -p --format=jpeg -d "$DEVICE" --mode=Color --swcrop=yes >$FILE_TO_UPLOAD
else
  scanadf -d "${DEVICE}" -N ${SCAN_OPTIONS} --source "${SCAN_SOURCE}"
  if [ ! -f image-0001 ] ; then
    exit 0;
  fi
  convert image* -adjoin uncompressed.pdf && rm image*
  gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$FILE_TO_UPLOAD uncompressed.pdf && rm uncompressed.pdf
fi

if [ -n "{$WEBDAV_URL}" ] ; then
  echo "Uploading $FILE_TO_UPLOAD to $WEBDAV_URL"
  curl -T $FILE_TO_UPLOAD -u $WEBDAV_USER_PASS $WEBDAV_URL
fi
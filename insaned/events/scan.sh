#!/bin/bash

DEVICE="${1}"
shift

if [ -z "$FOLDER" ] ; then
  FOLDER=$(mktemp -d --suffix=.scan)
fi
FILE_TO_UPLOAD=$(date +%Y%m%d_%H%M%S).pdf

cd "$FOLDER"
if [ "${SCAN_TYPE}" = "image" ] ; then
  FILE_TO_UPLOAD=$(date +%Y%m%d_%H%M%S).jpg
  scanimage -d "$DEVICE" $SCAN_OPTIONS >$FILE_TO_UPLOAD

  if [ ! -f $FILE_TO_UPLOAD ] ; then
    exit 0;
  fi
else
  scanadf -d "${DEVICE}" ${SCAN_OPTIONS} --source "${SCAN_SOURCE}"
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
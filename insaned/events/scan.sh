#!/bin/bash

DEVICE="${1}"
shift

if [ -z "$WORK_DIR" ] ; then
  WORK_DIR=$(mktemp -d --suffix=.scan)
fi
FILE_TO_UPLOAD=$(date +%Y%m%d_%H%M%S).pdf

$EXEC_START

cd "$WORK_DIR"
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

$EXEC_UPLOAD_START
if [ -n "${WEBDAV_URL}" ] ; then
  curl -T $FILE_TO_UPLOAD -u $WEBDAV_USER_PASS $WEBDAV_URL
fi

if [ -n "${RSYNC_PATH}" ] ; then
  echo "Uploading $FILE_TO_UPLOAD to $RSYNC_PATH"
  rsync $RSYNC_OPTIONS $FILE_TO_UPLOAD $RSYNC_PATH
fi

if [ -n "${LOCAL_PATH}" ] ; then
  echo "Copying $FILE_TO_UPLOAD to $LOCAL_PATH"
  cp "$FILE_TO_UPLOAD" "$LOCAL_PATH"
fi

if [ -n "${MAIL_RECV_ADDR}" ] ; then
  echo "Sending $FILE_TO_UPLOAD to ${MAIL_RECV_ADDR}"
  echo "New document: $FILE_TO_UPLOAD" | mutt -s "New document: $FILE_TO_UPLOAD" "${MAIL_RECV_ADDR}" -a "$FILE_TO_UPLOAD"
fi

$EXEC_FINISH

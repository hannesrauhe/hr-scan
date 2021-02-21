#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export DEFAULT_OPTIONS_FILE="${DIR}/default_options"
export CONFIG_FILE="${DIR}/config"

set -e
source "${DEFAULT_OPTIONS_FILE}"
if [ -f "${CONFIG_FILE}" ] ; then 
  source "${CONFIG_FILE}"
fi
set +e

# need to export CONFIG options so they are passed to correctly to scan.sh
export WEBDAV_USER_PASS
export WEBDAV_URL
export EXEC_START
export EXEC_OFF
export EXEC_ON
export EXEC_UPLOAD_START
export EXEC_FINISH
export FOLDER
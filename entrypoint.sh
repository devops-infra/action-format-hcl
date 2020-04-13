#!/usr/bin/env bash

set -e

# Return code
RET_CODE=0

# Run main action
/usr/bin/format-hcl

# TODO: handle parameters for format-hcl script
# TODO: use it for listing updated files

# Finish
if [[ ${RET_CODE} != "0" ]]; then
  echo " "
  echo "[ERROR] Check log for errors."
  echo " "
  exit 1
else
  # Pass in other cases
  echo " "
  echo "[INFO] No errors found."
  echo " "
  exit 0
fi

#!/usr/bin/env bash

set -e

# Return code
RET_CODE=0

# Run main action
/usr/bin/format-hcl
RET_CODE=$?

# TODO: handle parameters for format-hcl script

# List of changed files
FILES_CHANGED=$(git diff --staged --name-status)

# Info about changed files
if [[ ! -z ${FILES_CHANGED} ]]; then
  echo " "
  echo "[INFO] Updated files:"
  for FILE in ${FILES_CHANGED}; do
    echo "${FILE}"
  done
  echo " "
else
  echo " "
  echo "[INFO] No files updated."
  echo " "
fi

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

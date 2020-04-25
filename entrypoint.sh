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
if [[ -n ${FILES_CHANGED} ]]; then
  echo -e "\n[INFO] Updated files:"
  for FILE in ${FILES_CHANGED}; do
    echo "${FILE}"
  done
else
  echo -e "\n[INFO] No files updated."
fi

# Finish
if [[ ${RET_CODE} != "0" ]]; then
  echo -e "\n[ERROR] Check log for errors."
  exit 1
else
  # Pass in other cases
  echo -e "\n[INFO] No errors found."
  exit 0
fi

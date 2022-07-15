#!/usr/bin/env bash

set -e

# Return code
RET_CODE=0

# Print input variables
echo "Inputs:"
echo "  list: ${INPUT_LIST}"
echo "  write: ${INPUT_WRITE}"
echo "  ignore: ${INPUT_IGNORE}"
echo "  diff: ${INPUT_DIFF}"
echo "  check: ${INPUT_CHECK}"
echo "  recursive: ${INPUT_RECURSIVE}"
echo "  dir: ${INPUT_DIR}"

# Remap input variables as parameters for format-hcl
LIST="-list=${INPUT_LIST}"
WRITE="-write=${INPUT_WRITE}"

if [[ -n "${INPUT_IGNORE}" ]]; then
  IGNORE="-ignore=${INPUT_IGNORE}"
else
  IGNORE=""
fi

if [[ "${INPUT_DIFF}" == "true" ]]; then
  DIFF="-diff"
else
  DIFF=""
fi

if [[ "${INPUT_CHECK}" == "true" ]]; then
  CHECK="-check"
else
  CHECK=""
fi

if [[ "${INPUT_RECURSIVE}" == "true" ]]; then
  RECURSIVE="-recursive"
else
  RECURSIVE=""
fi

if [[ -n "${INPUT_DIR}" ]]; then
  DIR="${INPUT_DIR}"
else
  DIR=""
fi

# Run main action
/usr/bin/format-hcl "${LIST} ${WRITE} ${IGNORE} ${DIFF} ${CHECK} ${RECURSIVE} ${DIR}"
RET_CODE=$?

# List of changed files
FILES_CHANGED=$(git diff --cached --name-status)

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

#!/usr/bin/env bash

set -Eeuo pipefail

# Return code
RET_CODE=0

# Normalize inputs with safe defaults
INPUT_LIST="${INPUT_LIST:-false}"
INPUT_WRITE="${INPUT_WRITE:-true}"
INPUT_IGNORE="${INPUT_IGNORE:-}"
INPUT_DIFF="${INPUT_DIFF:-false}"
INPUT_CHECK="${INPUT_CHECK:-false}"
INPUT_RECURSIVE="${INPUT_RECURSIVE:-true}"
INPUT_DIR="${INPUT_DIR:-.}"

# Print input variables
echo "Inputs:"
echo "  list: ${INPUT_LIST}"
echo "  write: ${INPUT_WRITE}"
echo "  ignore: ${INPUT_IGNORE}"
#shellcheck disable=SC2153
echo "  diff: ${INPUT_DIFF}"
echo "  check: ${INPUT_CHECK}"
echo "  recursive: ${INPUT_RECURSIVE}"
echo "  dir: ${INPUT_DIR}"

if [[ "${INPUT_CHECK}" == "true" && "${INPUT_WRITE}" == "true" ]]; then
  echo "[INFO] check=true requires write=false; overriding write to false"
  INPUT_WRITE="false"
fi

# Remap input variables as parameters for format-hcl
ARGS=("-list=${INPUT_LIST}" "-write=${INPUT_WRITE}")

if [[ -n "${INPUT_IGNORE}" ]]; then
  ARGS+=("-ignore=${INPUT_IGNORE}")
fi

if [[ "${INPUT_DIFF}" == "true" ]]; then
  ARGS+=("-diff")
fi

if [[ "${INPUT_CHECK}" == "true" ]]; then
  ARGS+=("-check")
fi

if [[ "${INPUT_RECURSIVE}" == "true" ]]; then
  ARGS+=("-recursive")
fi

ARGS+=("${INPUT_DIR}")

# Run main action
touch /tmp/time_compare
/usr/bin/format-hcl "${ARGS[@]}"
RET_CODE=$?

# List of changed files
FILES_CHANGED=$(find . -newer /tmp/time_compare -type f)

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

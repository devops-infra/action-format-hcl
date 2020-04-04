#!/usr/bin/env sh

set -e

# GITHUB_TOKEN required
if [[ -z "${GITHUB_TOKEN}" ]]; then
  echo 'Missing env "GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}".'
  exit 1
fi

# Run main action
format-hcl

# List of changed files
FILES_CHANGED=$(git diff --name-only)

# Get the name of the current branch
BRANCH=${GITHUB_REF/refs\/heads\//}

# Info about formatted files
if [[ ${FILES_CHANGED} != "" ]]; then
  MESSAGE="Formated HCL files: ${FILES_CHANGED}"
else
  MESSAGE="No files where formatted."
fi

# Create auto commit
if [[ ${FILES_CHANGED} != "" && ${INPUT_PUSH_CHANGES} == "true" ]]; then
  echo " "
  REPO_URL="https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
  git config --global user.name ${GITHUB_ACTOR}
  git config --global user.email ${GITHUB_ACTOR}@users.noreply.github.com
  git commit -am "[AUTO] ${MESSAGE}"
  git push ${REPO_URL} HEAD:${BRANCH}
fi

# Summary
echo " "
echo "::set-output name=files_changed::${FILES_CHANGED}"
echo ${MESSAGE}
echo " "

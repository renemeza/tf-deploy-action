#!/bin/sh

set -e

COPY_SCRIPTS=${COPY_SCRIPTS:-"false"}
COPY_SCRIPTS_ONLY=${COPY_SCRIPTS_ONLY:-"false"}
COPY_SCRIPTS_DIR=${COPY_SCRIPTS_DIR:-"tf-deploy-action"}

copy_files() {
  echo "### Copying scripts to ${HOME}/${COPY_SCRIPTS_DIR}"
  mkdir -p "${HOME}/${COPY_SCRIPTS_DIR}"
  cp -R /usr/local/bin/* "${HOME}/${COPY_SCRIPTS_DIR}/."
}

if [ "$COPY_SCRIPTS_ONLY" = "true" ]; then
  copy_files
  exit 0
fi
if [ "$COPY_SCRIPTS" = "true" ]; then
  copy_files
fi

if [ "$#" -eq 0 ]; then
  deploy
else
  sh -c "$*"
fi

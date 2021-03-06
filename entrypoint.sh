#!/usr/bin/env sh

set -e

if [ ! -f "${COIN_NAME}" ]; then
  echo "Installing $COIN_NAME script"
  ./install.sh "${COIN_NAME}"
fi
echo "Installing $COIN_NAME daemon"
./"${COIN_NAME}" auto-install

echo "Starting $COIN_NAME daemon"
./"${COIN_NAME}" start
./"${COIN_NAME}" console
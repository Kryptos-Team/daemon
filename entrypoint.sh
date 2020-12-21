#!/usr/bin/env sh

set -e

./install.sh "${COIN_NAME}"
./"${COIN_NAME}" auto-install
./"${COIN_NAME}" start
./"${COIN_NAME}" console
#!/usr/bin/env sh

./install.sh coin_name "${COIN_NAME}"
./"${COIN_NAME}" install
./"${COIN_NAME}" start
./"${COIN_NAME}" console
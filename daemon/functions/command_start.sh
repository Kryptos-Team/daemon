#!/usr/bin/env bash

local command_name="START"
local command_action="Starting"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

info_config.sh

if [ "${short_name}" == "BTC" ]; then
  eval "${daemon_bin_dir}/bitcoind -conf=${daemon_config_file}"
elif [ "${short_name}" == "LTC" ]; then
  eval "${daemon_bin_dir}/litecoind -conf=${daemon_config_file}"
fi

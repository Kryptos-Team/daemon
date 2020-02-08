#!/usr/bin/env bash

local command_name="START"
local command_action="Starting"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

info_config.sh

if [ "${short_name}" == "BTC" ]; then
  eval "${daemon_bin_dir}/bitcoin-qt -conf=${daemon_config_file}"
elif [ "${short_name}" == "DOGE" ]; then
  eval "${daemon_bin_dir}/dogecoin-qt -conf=${daemon_config_file}"
elif [ "${short_name}" == "LTC" ]; then
  eval "${daemon_bin_dir}/litecoin-qt -conf=${daemon_config_file}"
else
  fn_print_error_nl "${daemon_name} does not support GUI"
  fn_script_log_error "${daemon_name} does not support GUI"
  core_exit.sh
fi

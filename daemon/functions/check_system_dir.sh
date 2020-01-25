#!/usr/bin/env bash

local command_name="CHECK"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

if [ ! -d "${daemon_files}" ]; then
  fn_print_fail_nl "Cannot access ${daemon_dir}: No such directory"
  if [ -d "${log_dir}" ]; then
    fn_script_log_fatal "Cannot access ${daemon_dir}: No such directory"
  fi
fi

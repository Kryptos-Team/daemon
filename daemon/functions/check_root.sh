#!/usr/bin/env bash

local command_name="CHECK"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

if [ "$(whoami)" == "root" ]; then
  if [ "${function_self_name}" != "command_install.sh" ]; then
    fn_print_fail_nl "Do NOT run this script as root!"
    if [ -d "${log_dir}" ]; then
      fn_script_log_fatal "${self_name} attempted to run as root."
    fi
    core_exit.sh
  fi
fi

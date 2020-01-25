#!/usr/bin/env bash

local command_name="CHECK"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

if [ ! -f "${executable_dir}/${exec_name}" ]; then
  fn_print_fail_nl "executable was not found"
  echo -e "${executable_dir}/${exec_name}"
  if [ -d "${log_dir}" ]; then
    fn_script_log_fatal "Executable was not found: ${executable_dir}/${exec_name}"
  fi
  unset exitbypass
  core_exit.sh
fi

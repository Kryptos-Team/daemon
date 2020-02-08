#!/usr/bin/env bash

local command_name="CHECK"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

fn_check_logs(){
  fn_print_dots "Checking for log files"
  fn_print_info_nl "Checking for log files: Creating log files"
  check_logs=1
  install_logs.sh
}
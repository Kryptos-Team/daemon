#!/usr/bin/env bash

local command_name="CONSOLE"
local command_action="Console"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

check.sh
fn_print_header

fn_print_information_nl "Press \"CTRL+b\" then \"d\" to exit the console"
fn_print_warning_nl "Do NOT press CTRL+c to exit"
echo -e ""

if ! fn_prompt_yn "Continue?" Y; then
  return
fi

fn_print_dots_nl "Accessing console"
check_status.sh

if [ "${status}" != "0" ]; then
  fn_print_ok_nl "Accessing console"
  fn_script_log_pass "Console accessed"
  tmux attach-session -t "${self_name}"
  fn_print_ok_nl "Closing console"
  fn_script_log_pass "Console closed"
else
  fn_print_error_nl "Daemon is not running"
  fn_script_log_error "Failed to access: Daemon is not running"
  if fn_prompt_yn "Do you want to start the server?" Y; then
    exitbypass=1
    command_start.sh
  fi
fi

core_exit.sh
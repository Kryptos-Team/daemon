#!/usr/bin/env bash

local command_name="INSTALL"
local command_action="Install"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

if [ "${check_logs}" != "1" ]; then
  echo -e ""
  echo -e "${lightyellow}Creating log directories${default}"
  fn_print_dash
fi

fn_sleep_time

# Create logs
echo -en "installing log dir: ${log_dir}..."
mkdir -p "${log_dir}"
if [ $? -ne 0 ]; then
  fn_print_fail_eol_nl
  core_exit.sh
else
  fn_print_ok_eol_nl
fi

fn_sleep_time
fn_script_log_info "Logs installed"

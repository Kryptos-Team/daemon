#!/usr/bin/env bash

local command_name="INSTALL"
local command_action="Install"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

echo -e ""
fn_print_dash

touch "${daemon_installed}"

echo -e "Install Complete!"
fn_script_log_info "Install Complete!"
echo -e ""
echo -e "To start daemon type:"
echo -e "./${self_name} start"
echo -e ""
core_exit.sh

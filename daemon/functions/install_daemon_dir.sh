#!/usr/bin/env bash

local command_name="INSTALL"
local command_action="Install"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

echo -e ""
echo -e "${lightyellow}${daemon_name} Directory${default}"
echo -e "================================="
fn_sleep_time
if [ -d "${daemon_files}" ]; then
  fn_print_warning_nl "A daemon is already installed here"
fi
pwd
echo -e ""
if ! fn_prompt_yn "Continue?" Y; then
  exit
fi

if [ ! -d "${daemon_files}" ]; then
  mkdir -v "${daemon_files}"
fi

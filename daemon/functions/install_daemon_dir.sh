#!/usr/bin/env bash

local command_name="INSTALL"
local command_action="Install"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

echo -e ""
echo -e "${lightyellow}${daemon_name} Directory${default}"
fn_print_dash
fn_sleep_time
if [ -f "${daemon_installed}" ]; then
  fn_print_warning_nl "A daemon is already installed here"
  exit
fi
echo -e "${daemon_files}"
echo -e ""
if [ -z "${auto_install}" ]; then
  if ! fn_prompt_yn "Continue?" Y; then
    exit
  fi
fi

if [ ! -d "${daemon_files}" ]; then
  mkdir -v "${daemon_files}"
fi

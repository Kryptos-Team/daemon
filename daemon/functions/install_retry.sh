#!/usr/bin/env bash

local command_name="INSTALL"
local command_action="Install"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

if fn_prompt_yn "Retry install?" Y; then
  command_install.sh
  core_exit.sh
else
  core_exit.sh
fi

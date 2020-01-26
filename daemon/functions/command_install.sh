#!/usr/bin/env bash

local command_name="INSTALL"
local command_action="Install"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

check.sh

if [ "$(whoami)" == "root" ]; then
  check_deps.sh
else
  install_header.sh
  install_daemon_dir.sh
  install_logs.sh
  check_deps.sh
  install_daemon_files.sh
  install_config.sh
  install_complete.sh
fi

core_exit.sh

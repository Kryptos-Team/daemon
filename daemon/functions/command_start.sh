#!/usr/bin/env bash

local command_name="START"
local command_action="Starting"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

info_config.sh

eval "${daemon_bin_dir}/${daemon_name} -conf=${daemon_config_file}"
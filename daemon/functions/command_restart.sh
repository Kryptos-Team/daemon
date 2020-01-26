#!/usr/bin/env bash

local command_name="RESTART"
local command_action="Restarting"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

info_config.sh
exitbypass=1
command_stop.sh
command_start.sh

core_exit.sh
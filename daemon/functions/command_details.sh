#!/usr/bin/env bash

local command_name="DETAILS"
local command_action="Details"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

check.sh
info_config.sh
info_distro.sh
info_messages.sh
fn_info_message_distro
fn_info_message_server_resource
fn_info_message_daemon_resource
fn_info_message_daemon
fn_info_logs
fn_info_message_statusbottom
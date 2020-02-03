#!/usr/bin/env bash

local command_name="UPDATE"
local command_action="Update"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

fn_print_dots_nl ""
check.sh

fn_script_log_fatal "NOT IMPLEMENTED"
fn_print_error_nl "METHOD NOT IMPLEMENTED"
fn_sleep_time

core_exit.sh

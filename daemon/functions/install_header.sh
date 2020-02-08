#!/usr/bin/env bash

local command_name="INSTALL"
local command_action="Install"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

clear
fn_print_ascii_logo
fn_sleep_time
fn_print_dash
echo -e "${lightyellow}Kryptos${default} Team"
echo -e "by Abhimanyu Saharan"
echo -e "${lightblue}Daemon:${default} ${daemon_name}"
echo -e "${lightblue}Donate:${default} https://paypal.me/abhimanyusaharan"
fn_print_dash
fn_sleep_time
#!/usr/bin/env bash

local command_name="CONSOLE"
local command_action="Console"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

echo -e "${lightyellow}Support Kryptos Team${default}"
fn_print_dash
echo -e ""
echo -e "Been using Kryptos"
echo -e "Consider donating to support development"
echo -e ""
echo -e "* ${lightblue}BTC:${default}    3542EMxkgirJBbWN33NqUCPhZ89vvjeWsR"
echo -e "* ${lightblue}LTC:${default}    LTSsbhiP3nAUanq7cPbGXfDNuxPr8VMvv1"
echo -e "* ${lightblue}XMR:${default}    8BqPZB339MkZaJ7SLSW31vJ9zqdfL5YTTHYVrVU2i11newcLyXmnBoy5Ku72xzMrEta6hoVhymVZxesVvaR2knAR9qXxfRx"
echo -e "* ${lightblue}Paypal:${default} https://paypal.me/abhimanyusaharan"
echo -e ""
echo -e "Kryptos Team est. 2020"

core_exit.sh
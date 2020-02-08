#!/usr/bin/env bash

local command_name="CHECK"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

info_distro.sh

# RAM requirements in MB for each coin daemon
if [ "${short_name}" == "BTC" ]; then
  ram_req_mb="1024"
  ram_req_gb="1"
elif [ "${short_name}" == "DOGE" ] || [ "${short_name}" == "LTC" ] || [ "${short_name}" == "NMC" ]; then
  ram_req_mb="2048"
  ram_req_gb="2"
fi

# If the daemon has a minimum RAM requirement, compare it to your sysem's available RAM
if [ -n "${ram_req_mb}" ]; then
  if [ "${phys_mem_total_mb}" -lt "${ram_req_mb}" ]; then
    fn_print_dots_nl "Check RAM"
    # Warn the user
    fn_print_warn_nl "Check RAM: ${ram_req_gb}GB required, ${phys_mem_total} available"
    echo " * ${daemon_name} daemon may fail to run or experience poor performance"
    fn_sleep_time
  fi
fi

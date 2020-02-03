#!/usr/bin/env bash

local command_name="INSTALL"
local command_action="Install"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

fn_install_daemon_files() {
  if [ "${short_name}" == "BTC" ]; then
    local_file_name="bitcoin-0.19.0.1-x86_64-linux-gnu.tar.gz"
    remote_file_url="https://bitcoin.org/bin/bitcoin-core-0.19.0.1/${local_file_name}"
    local_file_dir="${tmp_dir}"
    chmodx="nochmodx"
    run="norun"
    force="noforce"
    md5="2ba6f3b6b3ebc80d4d60147ae7f4eacb"
  elif [ "${short_name}" == "DOGE" ]; then
    local_file_name="dogecoin-1.14.2-x86_64-linux-gnu.tar.gz"
    remote_file_url="https://github.com/dogecoin/dogecoin/releases/download/v1.14.2/${local_file_name}"
    local_file_dir="${tmp_dir}"
    chmodx="nochmodx"
    run="norun"
    forcedl="noforcedl"
    md5="ecc01479161d3c872f0b725f184c8983"
  elif [ "${short_name}" == "LTC" ]; then
    local_file_name="litecoin-0.17.1-x86_64-linux-gnu.tar.gz"
    remote_file_url="https://download.litecoin.org/litecoin-0.17.1/linux/${local_file_name}"
    local_file_dir="${tmp_dir}"
    chmodx="nochmodx"
    run="norun"
    forcedl="noforcedl"
    md5="a152828cd984c4dda16719aa406609ff"
  fi

  fn_fetch_file "${remote_file_url}" "${local_file_dir}" "${local_file_name}" "${chmodx}" "${run}" "${forcedl}" "${md5}"
  fn_dl_extract "${local_file_dir}" "${local_file_name}" "${daemon_files}"
}

echo -e ""
echo -e "${lightyellow}Installing ${daemon_name} daemon${default}"
echo -e "=================================="
fn_sleep_time

fn_install_daemon_files

echo -e ""
echo -e "==================================="
if [ -z "${auto_install}" ]; then
  if ! fn_prompt_yn "Was the install successful?" Y; then
    install_retry.sh
  fi
fi

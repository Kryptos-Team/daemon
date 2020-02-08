#!/usr/bin/env bash

local command_name="INSTALL"
local command_action="Install"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

fn_install_daemon_files() {
  if [ "${short_name}" == "BTC" ]; then
    local_file_name="bitcoin-${daemon_version}-x86_64-linux-gnu.tar.gz"
    local_dir_name="bitcoin-${daemon_version}"
    remote_file_url="https://bitcoin.org/bin/bitcoin-core-${daemon_version}/${local_file_name}"
    chmodx="nochmodx"
    run="norun"
    forcedl="noforce"
    md5="2ba6f3b6b3ebc80d4d60147ae7f4eacb"
  elif [ "${short_name}" == "DOGE" ]; then
    local_file_name="dogecoin-${daemon_version}-x86_64-linux-gnu.tar.gz"
    local_dir_name="dogecoin-${daemon_version}"
    remote_file_url="https://github.com/dogecoin/dogecoin/releases/download/v${daemon_version}/${local_file_name}"
    chmodx="nochmodx"
    run="norun"
    forcedl="noforcedl"
    md5="ecc01479161d3c872f0b725f184c8983"
  elif [ "${short_name}" == "LTC" ]; then
    local_file_name="litecoin-${daemon_version}-x86_64-linux-gnu.tar.gz"
    local_dir_name="litecoin-${daemon_version}"
    remote_file_url="https://download.litecoin.org/litecoin-${daemon_version}/linux/${local_file_name}"
    chmodx="nochmodx"
    run="norun"
    forcedl="noforcedl"
    md5="a152828cd984c4dda16719aa406609ff"
  fi

  fn_fetch_file "${remote_file_url}" "${tmp_dir}" "${local_file_name}" "${chmodx}" "${run}" "${forcedl}" "${md5}"
  fn_dl_extract "${tmp_dir}" "${local_file_name}" "${daemon_files}"

  echo -en "copying ${daemon_files}/${local_dir_name}/bin..."
  cp -rf "${daemon_files}/${local_dir_name}/bin" "${daemon_files}"
  local exitcode=$?
  if [ "${exitcode}" -ne 0 ]; then
    fn_print_fail_eol_nl
    if [ -f "${daemon_logs}" ]; then
      fn_script_log_fatal "copying ${daemon_files}/${local_dir_name}/bin"
    fi
    core_exit.sh
  else
    fn_print_ok_eol_nl
    if [ -f "${daemon_logs}" ]; then
      fn_script_log_pass "copying ${daemon_files}/${local_dir_name}/bin"
    fi
  fi

  echo -en "copying ${daemon_files}/${local_dir_name}/share..."
  cp -rf "${daemon_files}/${local_dir_name}/share" "${daemon_files}"
  local exitcode=$?
  if [ "${exitcode}" -ne 0 ]; then
    fn_print_fail_eol_nl
    if [ -f "${daemon_logs}" ]; then
      fn_script_log_fatal "copying ${daemon_files}/${local_dir_name}/bin"
    fi
    core_exit.sh
  else
    fn_print_ok_eol_nl
    if [ -f "${daemon_logs}" ]; then
      fn_script_log_pass "copying ${daemon_files}/${local_dir_name}/bin"
    fi
  fi

  echo -en "removing ${daemon_files}/${local_dir_name}..."
  rm -rf "${daemon_files}/${local_dir_name}"
  local exitcode=$?
  if [ "${exitcode}" -ne 0 ]; then
    fn_print_fail_eol_nl
    if [ -f "${daemon_logs}" ]; then
      fn_script_log_fatal "removing ${daemon_files}/${local_dir_name}"
    fi
    core_exit.sh
  else
    fn_print_ok_eol_nl
    if [ -f "${daemon_logs}" ]; then
      fn_script_log_pass "removing ${daemon_files}/${local_dir_name}"
    fi
  fi
}

echo -e ""
echo -e "${lightyellow}Installing ${daemon_name} daemon${default}"
fn_print_dash
fn_sleep_time

fn_install_daemon_files

echo -e ""
fn_print_dash
if [ -z "${auto_install}" ]; then
  if ! fn_prompt_yn "Was the install successful?" Y; then
    install_retry.sh
  fi
fi

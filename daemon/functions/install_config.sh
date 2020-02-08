#!/usr/bin/env bash

local command_name="INSTALL"
local command_action="Install"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

# Checks if daemon config directory exists, creates it if missing
fn_check_cfg_dir() {
  if [ ! -d "${daemon_cfg_dir}" ]; then
    echo -e "creating ${daemon_cfg_dir} config directory"
    fn_script_log_info "creating ${daemon_cfg_dir} config directory"
    mkdir -pv "${daemon_cfg_dir}"
  fi
}

fn_fetch_default_config() {
  echo -e ""
  echo -e "${lightyellow}Downloading ${daemon_name} configuration${default}"
  echo -e "====================================="
  fn_sleep_time
  fn_fetch_file "https://raw.githubusercontent.com/Kryptos-Team/daemon/master/daemon/configurations/${short_name}/${config}" "${default_config_dir}/${short_name}" "coin.conf" "nochmodx" "norun" "forcedl" "nomd5"
}

fn_default_config_local() {
  echo -e "copying configuration file"
  cp -nv "${default_config_dir}/${short_name}/coin.conf" "${daemon_config_file}/"
  fn_sleep_time
}

fn_set_config_vars() {
  if [ -f "${daemon_config_file}" ]; then
    user_random="$(tr -dc A-Za-z0-9_ </dev/urandom | head -c 8 | xargs)"
    password_random="$(tr -dc A-Za-z0-9_ </dev/urandom | head -c 8 | xargs)"
    rpcuser="user_${user_random}"
    rpcpassword="${password_random}"
    echo -e "changing rpcuser/rpcpassword"
    fn_script_log_info "changing rpcuser/rpcpassword"
    sed -i "s/RPCADMINUSER/${rpcuser}/g" "${daemon_cfg_dir}/${config}"
    sed -i "s/RPCADMINPASSWORD/${rpcpassword}/g" "${daemon_cfg_dir}/${config}"
    fn_sleep_time
  else
    fn_print_warning_nl "Configuration file not found, cannot alter it"
    fn_script_log_warn "Configuration file not found, cannot alter it"
    fn_sleep_time
  fi
}

fn_check_cfg_dir
fn_fetch_default_config
fn_default_config_local
fn_set_config_vars

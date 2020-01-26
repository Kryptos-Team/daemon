#!/usr/bin/env bash

core_dl.sh() {
  function_file="${FUNCNAME[0]}"
  fn_bootstrap_fetch_file_github "daemon/functions" "core_dl.sh" "${functions_dir}" "chmodx" "run" "noforcedl" "nomd5"
}

core_messages.sh() {
  function_file="${FUNCNAME[0]}"
  fn_bootstrap_fetch_file_github "daemon/functions" "core_messages.sh" "${functions_dir}" "chmodx" "run" "noforcedl" "nomd5"
}

core_exit.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

core_getopt.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

core_trap.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

# Commands
command_debug.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

command_details.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

command_start.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

command_stop.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

command_install.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

command_restart.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

command_wipe.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

command_donate.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

# Checks
check.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

check_deps.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

check_executable.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

check_ip.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

check_logs.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

check_permissions.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

check_root.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

check_tmuxexception.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

check_system_requirements.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

# Info
info_status.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

info_distro.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

# Logs

logs.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

# Update
command_update_functions.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

command_update_daemon.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

command_update.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

fn_update_functions.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

# Installer functions
install_complete.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

install_logs.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

install_retry.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

install_daemon_dir.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

install_header.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

install_daemon_files.sh() {
  function_file="${FUNCNAME[0]}"
  fn_fetch_function
}

# Creates tmp dir if missing
if [ ! -d "${tmp_dir}" ]; then
  mkdir -p "${tmp_dir}"
fi

# Calls on-screen messages (bootstrap)
core_messages.sh

# Calls file downloader (bootstrap)
core_dl.sh

# Calls the global Ctrl+C trap
core_trap.sh

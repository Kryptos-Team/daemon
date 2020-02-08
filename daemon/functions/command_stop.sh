#!/usr/bin/env bash

local command_name="STOP"
local command_action="Stopping"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

# Attempts graceful shutdown by sending CTRL+c
fn_stop_graceful_ctrlc() {
  fn_print_dots_nl "Graceful: CTRL+c"
  fn_script_log_info "Graceful: CTRL+c"

  # Sends quit
  tmux send-keys -t "${self_name}" C-c >/dev/null 2>&1
  # Waits upto 5 minutes giving the daemon to shutdown gracefully
  for seconds in {1..300}; do
    check_status.sh
    if [ "${status}" == "0" ]; then
      fn_print_ok "Graceful: CTRL+c: ${seconds} seconds: "
      fn_print_ok_eol_nl
      fn_script_log_pass "Graceful: CTRL+c: ${seconds} seconds"
      break
    fi
    sleep 1
    fn_print_dots_nl "Graceful: CTRL+c: ${seconds} seconds"
  done

  check_status.sh
  if [ "${status}" != "0" ]; then
    fn_print_error "Graceful: CTRL+c: "
    fn_print_fail_eol_nl
    fn_script_log_error "Graceful: CTRL+c: FAIL"
  fi
  fn_sleep_time
}

fn_stop_tmux() {
  fn_print_dots_nl "${daemon_name}"
  fn_script_log_info "tmux kill-session: ${daemon_name}"

  # Kill tmux session
  tmux kill-session -t "${self_name}" >/dev/null 2>&1
  fn_sleep_time
  check_status.sh
  if [ "${status}" == "0" ]; then
    fn_print_ok_nl "Stopped ${daemon_name}"
    fn_script_log_pass "Stopped ${daemon_name}"
  else
    fn_print_fail_nl "Unable to stop ${daemon_name}"
    fn_script_log_fatal "Unable to stop ${daemon_name}"
  fi
}

fn_stop_pre_check() {
  if [ "${status}" == "0" ]; then
    fn_print_info_nl "${daemon_name} is already stopped"
    fn_script_log_error "${daemon_name} is already stopped"
  else
    fn_stop_graceful_ctrlc
  fi

  # Check status again, if a kill tmux graceful shutdown failed
  check_status.sh
  if [ "${status}" != "0" ]; then
    fn_stop_tmux
  fi
}

fn_print_dots_nl "${daemon_name}"
info_config.sh
fn_stop_pre_check

# Remove lockfile
if [ -f "${root_dir}/${lock_selfname}" ]; then
  rm -rf "${root_dir}/${lock_selfname}"
fi

if [ -z "${exitbypass}" ]; then
  core_exit.sh
fi

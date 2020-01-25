#!/usr/bin/env bash

local command_name="CHECK"

fn_check_is_in_tmux() {
  if [ -n "${TMUX}" ]; then
    fn_print_fail_nl "${self_name} error: Sorry, you cannot start a tmux session inside of a tmux session"
    fn_script_log_fatal "${self_name} error: Attempted to start a tmux session inside of a tmux session"
    fn_print_information_nl "We will create a new session while starting the daemon"
    core_exit.sh
  fi
}

fn_check_is_in_screen() {
  if [ -n "${STY}" ]; then
    fn_print_fail_nl "${self_name} error: Sorry, you cannot start a tmux session inside of a tmux session"
    fn_script_log_fatal "${self_name} error: Attempted to start a tmux session inside of a tmux session"
    fn_print_information_nl "We will create a new session while starting the daemon"
    core_exit.sh
  fi
}

fn_check_is_in_tmux
fn_check_is_in_screen

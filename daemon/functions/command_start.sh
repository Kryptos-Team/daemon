#!/usr/bin/env bash

local command_name="START"
local command_action="Starting"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

fn_start_tmux() {
  session_width=80
  session_height=23

  # Create lock file
  date >"${root_dir}/${lock_selfname}"

  tmux new-session -d -x "${session_width}" -y "${session_height}" -s "${self_name}" "${daemon_bin_dir}/${daemon_name} -conf=${daemon_config_file}" 2>"${root_dir}/.${self_name}-tmux-error.tmp"

  touch "${console_log}"

  # Get tmux version
  tmux_version=$(tmux -V | sed "s/tmux //" | sed -n '1 p')
  # Tmux compiled from source will return "master", therefore ignore it
  if [ "${tmux_version}" == "master" ]; then
    fn_script_log "Tmux version: master (user compiled)"
    echo -e "Tmux version: master (user compiled)" >>"${console_log}"
    tmux pipe-name -o -t "${self_name}" "exec cat >> '${console_log}'"
  elif [ -n "${tmux_version}" ]; then
    # Get the digit version of th tmux
    tmux_version=$(tmux -V | sed "s/tmux //" | sed -n '1 p' | tr -cd '[:digit:]')
    # tmux pipe-pane not supported in tmux version < 1.6
    if [ "${tmux_version}" -lt "16" ]; then
      echo -e "Console logging disabled: Tmux => 1.6 required
               Currently installed: $(tmux -V)" >"${console_log}"
    elif [ "${tmux_version}" -lt "18" ]; then
      echo -e "Console logging disabled: Bug in Tmux 1.8 breaks logging
               Currently installed: $(tmux -V)" >"${console_log}"
    else
      tmux pipe-pane -o -t "${self_name}" "exec cat >> '${console_log}'"
    fi
  else
    echo -e "Unable to detect tmux version" >>"${console_log}"
    fn_script_log_warn "Unable to detect tmux version"
  fi

  fn_sleep_time

  # If the server fails to start
  check_status.sh
  if [ "${status}" == "0" ]; then
    fn_print_fail_nl "Unable to start ${daemon_name}"
    fn_script_log_fatal "Unable to start ${daemon_name}"

    if [ -f "${root_dir}/.${self_name}-tmux-error.tmp" ]; then
      fn_print_fail_nl "Unable to start ${daemon_name}: Tmux error:"
      fn_script_log_fatal "Unable to start ${daemon_name}: Tmux error:"
      echo -e ""
      echo -e "Command"
      fn_print_dash
      echo -e "tmux new-session -d -s \"${self_name}\" \"${daemon_bin_dir}/${daemon_name} -conf=${daemon_config_file}\"" | tee -a "${console_log}"
      echo -e ""
      echo -e "Error"
      fn_print_dash
      cat "${root_dir}/.${self_name}-tmux-error.tmp" | tee -a "${console_log}"

      # Detected error
      if grep -c "Operation not supported" "${root_dir}/.${self_name}-tmux-error.tmp"; then
        echo -e ""
        echo -e "Fix"
        fn_print_dash
        if ! grep "tty:" /etc/group | grep "$(whoami)"; then
          echo -e "$(whoami) is not part of the tty group"
          group=$(grep tty /etc/group)
          echo -e ""
          echo -e "${group}"
          fn_script_log_info "${group}"
          echo -e ""
          echo -e "Run the following command with root privileges"
          echo -e ""
          echo -e "usermod -G tty $(whoami)"
          echo -e ""
        else
          echo -e "No known fix currently. Please log an issue"
          fn_script_log_info "No known fix currently. Please log an issue"
          echo -e "https://github.com/Kryptos-Team/daemon/issue/new"
          fn_script_log_info "https://github.com/Kryptos-Team/daemon/issue/new"
        fi
      fi
    fi

    core_exit.sh
  else
    fn_print_ok "${daemon_name}"
    fn_script_log_pass "Started ${daemon_name}"
  fi
  rm "${root_dir}/.${self_name}-tmux-error.tmp"
  echo -en "\n"
}

check.sh

fn_print_dots "${daemon_name}"

info_config.sh
fn_start_tmux

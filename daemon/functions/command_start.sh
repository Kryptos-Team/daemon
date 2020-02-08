#!/usr/bin/env bash

local command_name="START"
local command_action="Starting"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

fn_start_tmux() {
  session_width=80
  session_height=23

  # Create lock file
  date >"${root_dir}/${lock_selfname}"

  tmux new-session -x "${session_width}" -y "${session_height}" -s "${self_name}" "${daemon_bin_dir}/${daemon_name} -conf=${daemon_config_file}" 2>"${root_dir}/.${self_name}-tmux-error.log"

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
    echo -e "Unable to detect tmux version" >> "${console_log}"
    fn_script_log_warn "Unable to detect tmux version"
  fi

  fn_sleep_time
}

info_config.sh
fn_start_tmux

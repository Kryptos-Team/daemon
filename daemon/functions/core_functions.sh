#!/usr/bin/env bash

core_dl.sh() {
  function_file="${FUNCNAME[0]}"
  fn_bootstrap_fetch_file_github "daemon/functions" "core_dl.sh" "${functions_dir}" "chmodx" "run" "noforcedl" "nomd5"
}

core_messages.sh() {
  function_file="${FUNCNAME[0]}"
  fn_bootstrap_fetch_file_github "daemon/functions" "core_messages.sh" "${functions_dir}" "chmodx" "run" "noforcedl" "nomd5"
}

core_trap.sh() {
  function_file="${FUNCNAME[0]}"
  fn_bootstrap_fetch_file_github "daemon/functions" "core_trap.sh" "${functions_dir}" "chmodx" "run" "noforcedl" "nomd5"
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

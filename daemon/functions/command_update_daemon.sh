#!/usr/bin/env bash

local command_name="UPDATE DEAMON"
local command_action="Updating Daemon"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

fn_print_dots_nl "Updating Daemon"
check.sh
fn_script_log_info "Updating Daemon"
echo -en "\n"

# Check and update functions
if [ -n "${functions_dir}" ]; then
  if [ -d "${functions_dir}" ]; then
    cd "${functions_dir}" || exit
    for function_file in *; do
      echo -en "checking function ${function_file}... \c"
      github_file_url_dir="daemon/functions"
      get_function_file=$(curl --fail -s "https://raw.githubusercontent.com/${githubuser}/${githubrepo}/${githubbranch}/${github_file_url_dir}/${function_file}")
      exitcode=$?
      function_file_diff=$(diff "${functions_dir}/${function_file}" <(curl --fail -s "https://raw.githubusercontent.com/${githubuser}/${githubrepo}/${githubbranch}/${github_file_url_dir}/${function_file}"))
      if [ "${exitcode}" -ne 0 ]; then
        fn_print_fail_eol_nl
        echo -en "removing unknown function ${function_file}... \c"
        fn_script_log_fatal "removing unknown function ${function_file}"
        if ! rm -f "${function_file}"; then
          fn_print_fail_eol_nl
          core_exit.sh
        else
          fn_print_ok_eol_nl
        fi
      elif [ "${function_file_diff}" != "" ]; then
        fn_print_update_eol_nl
        fn_script_log_info "checking function ${function_file}: UPDATE"
        rm -rf "${functions_dir:?}/${function_file}"
        fn_update_function
      else
        fn_print_ok_eol_nl
      fi
    done
  fi
fi

if [ "${exitcode}" != "0" ] && [ -n "${exitcode}" ]; then
  fn_print_fail "Updating functions"
  fn_script_log_fatal "Updating functions"
else
  fn_print_ok "Updating functions"
  fn_script_log_pass "Updating functions"
fi

core_exit.sh

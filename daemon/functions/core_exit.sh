#!/usr/bin/env bash

fn_exit_debug() {
  if [ -f "${root_dir}/.debug" ]; then
    echo -e ""
    echo -e "${function_self_name} exiting with code: ${exitcode}"
    if [ -f "${root_dir}/debug.log" ]; then
      grep "function_file=" "${root_dir}/debug.log" | sed 's/function_file=//g' >"${root_dir/debug-function-order.log/}"
    fi
  fi
}

# If running dependency check as root will remove any files that belong to root user
if [ "${whoami}" == "root" ]; then
  find "${log_dir}"/ -group root -prune -exec rm -rf {} + >/dev/null 2>&1
fi

if [ -n "${exitbypass}" ]; then
  unset exitbypass
elif [ -n "${exitcode}" ] && [ "${exitcode}" != "0" ]; then
  if [ "${exitcode}" == "1" ]; then
    fn_script_log_fatal "${function_self_name} exiting with code: ${exitcode}"
  elif [ "${exitcode}" == "2" ]; then
    fn_script_log_error "${function_self_name} exiting with code: ${exitcode}"
  elif [ "${exitcode}" == "3" ]; then
    fn_script_log_warn "${function_self_name} exiting with code: ${exitcode}"
  else
    fn_script_log_warn "${function_self_name} exiting with code: ${exitcode}"
  fi
  fn_exit_debug
  # remove trap
  trap - INT
  exit "${exitcode}"
else
  fn_script_log_pass "${function_self_name} exiting with code: ${exitcode}"
  fn_exit_debug
  # remove trap
  trap - INT
  exit "${exitcode}"
fi

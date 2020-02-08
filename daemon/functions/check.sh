#!/usr/bin/env bash

local command_name="CHECK"

# Every command that requires checks kust references check.sh
# check.sh selects which checks to run by using arrays

if [ "${user_input}" != "install" ] && [ "${user_input}" != "i" ]; then
  check_root.sh
fi

check_tmuxexception.sh

if [ "${function_self_name}" != "command_install.sh" ] && [ "${function_self_name}" != "command_update_functions.sh" ] && [ "${function_self_name}" != "command_update.sh" ]; then
  check_system_dir.sh
fi

local allowed_commands_array=(command_start.sh command_debug.sh)
for allowed_command in "${allowed_commands_array[@]}"; do
  if [ "${allowed_command}" == "${function_self_name}" ]; then
    check_executables.sh
  fi
done


local allowed_commands_array=(command_start.sh command_debug.sh command_install.sh)
for allowed_command in "${allowed_commands_array[@]}"; do
  if [ "${allowed_command}" == "${function_self_name}" ]; then
    check_system_requirements.sh
  fi
done

local allowed_commands_array=(command_start.sh command_install.sh command_update.sh command _gui.sh command_restart.sh command_update_daemon.sh)
for allowed_command in "${allowed_commands_array[@]}"; do
  if [ "${allowed_command}" == "${function_self_name}" ]; then
    check_logs.sh
  fi
done

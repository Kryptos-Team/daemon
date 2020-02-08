#!/usr/bin/env bash

local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

### Define all commands here
## User commands | Trigger commands | Description
# Standard commands
cmd_autoinstall=("ai;auto-install" "fn_autoinstall" "Automatically install coin daemon with default configurations")
cmd_install=("i;install" "command_install.sh" "Install coin daemon")
cmd_start=("st;start" "command_start.sh" "Start the daemon")
cmd_stop=("sp;stop" "command_stop.sh" "Stop the daemon")
cmd_restart=("r;restart" "command_restart.sh" "Restart the daemon")
cmd_gui=("g;gui" "command_gui.sh" "Start GUI  (if available)")
cmd_console=("c;console" "command_console.sh" "Access daemon console")
cmd_details=("dt;details" "command_details.sh" "Display the daemon information")
cmd_donate=("do;donate" "command_donate.sh" "Donation options")
cmd_debug=("d;debug" "command_debug.sh" "Enable/disbale debug mode")
cmd_update=("uc;update-coin" "command_update.sh" "Check and apply daemon update")
cmd_update_daemon=("ud;update-daemon" "command_update_daemon.sh" "Check and apply any core Daemon updates")

### Set specific opt here
currentopt=("${cmd_start[@]}" "${cmd_stop[@]}" "${cmd_restart[@]}" "${cmd_details[@]}" "${cmd_gui[@]}")

# Debug
currentopt+=("${cmd_console[@]}" "${cmd_debug[@]}")

# Installer
currentopt+=("${cmd_autoinstall[@]}" "${cmd_install[@]}" "${cmd_update[@]}" "${cmd_update_daemon[@]}")

# Donate
currentopt+=("${cmd_donate[@]}")

### Build list of available commands
optcommands=()
index="0"
for ((index = "0"; index < ${#currentopt[@]}; index += 3)); do
  cmdamount=$(echo -e "${currentopt[index]}" | awk -F ';' '{ print NF }')
  for ((cmdindex = 1; cmdindex <= cmdamount; cmdindex++)); do
    optcommands+=("$(echo -e "${currentopt[index]}" | awk -F ';' -v x=${cmdindex} '{ print $x }')")
  done
done

# Shows usage
fn_opt_usage() {
  echo -e "Usage: $0 [option]"
  echo -e ""
  echo -e "Kryptos Team - ${daemon_name} - Version ${version}"
  echo -e ""
  echo -e "${lightyellow}Commands${default}"
  # Display available commands
  index="0"
  {
    for ((index = "0"; index < ${#currentopt[@]}; index += 3)); do
      echo -e "${cyan}$(echo -e "${currentopt[index]}" | awk -F ';' '{ print $2 }')\t${default}$(echo -e "${currentopt[index]}" | awk -F ';' '{ print $1 }')\t| ${currentopt[index + 2]}"
    done
  } | column -s $'\t' -t
  core_exit.sh
}

# Check if user commands exist and run corresponding scripts else display usage
if [ -z "${getopt}" ]; then
  fn_opt_usage
fi

# Command exists.
for i in "${optcommands[@]}"; do
  if [ "${i}" == "${getopt}" ]; then
    # Seek and run command.
    index="0"
    for ((index = "0"; index < ${#currentopt[@]}; index += 3)); do
      currcmdamount=$(echo -e "${currentopt[index]}" | awk -F ';' '{ print NF }')
      for ((currcmdindex = 1; currcmdindex <= currcmdamount; currcmdindex++)); do
        if [ "$(echo -e "${currentopt[index]}" | awk -F ';' -v x=${currcmdindex} '{ print $x }')" == "${getopt}" ]; then
          # Run command.
          eval "${currentopt[index + 1]}"
          core_exit.sh
          break
        fi
      done
    done
  fi
done

# If we are executing this, it means the command does not exist
echo -e "${red}Unknown command${default}: $0 ${getopt}"
exitcode=2
fn_opt_usage
core_exit.sh

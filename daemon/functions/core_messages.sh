#!/usr/bin/env bash

fn_ansi_loader() {
  if [ "${ansi}" != "off" ]; then
    # echo colors
    default="\e[0m"
    black="\e[30m"
    red="\e[31m"
    lightred="\e[91m"
    green="\e[32m"
    lightgreen="\e[92m"
    yellow="\e[33m"
    lightyellow="\e[93m"
    blue="\e[34m"
    lightblue="\e[94m"
    magenta="\e[35m"
    lightmagenta="\e[95m"
    cyan="\e[36m"
    lightcyan="\e[96m"
    darkgrey="\e[90m"
    lightgrey="\e[37m"
    white="\e[97m"
  fi
  # carriage return and erase to end of line
  creeol="\e[033K"
}

fn_sleep_time() {
  if [ "${sleeptime}" != "0" ] || [ "${travistest}" != "1" ]; then
    if [ -z "${sleeptime}" ]; then
      sleeptime=3
    fi
    sleep "${sleeptime}"
  fi
}

# Log display
## Jan 26 01:37:20 litecoind: Install:
fn_script_log() {
  if [ -d "${log_dir}" ]; then
    if [ -n "${command_name}" ]; then
      echo -e "$(date '+%b %d %H:%M:%S.%3N') ${self_name}: ${command_name}: ${1}" >>"${daemon_logs}"
    else
      echo -e "$(date '+%b %d %H:%M:%S.%3N') ${self_name}: ${1}" >>"${daemon_logs}"
    fi
  fi
}

## Jan 26 01:37:20 litecoind: Install: PASS:
fn_script_log_pass() {
  if [ -d "${log_dir}" ]; then
    if [ -n "${command_name}" ]; then
      echo -e "$(date '+%b %d %H:%M:%S.%3N') ${self_name}: ${command_name}: PASS: ${1}" >>"${daemon_logs}"
    else
      echo -e "$(date '+%b %d %H:%M:%S.%3N') ${self_name}: PASS: ${1}" >>"${daemon_logs}"
    fi
  fi
  exitcode=0
}

## Jan 26 01:37:20 litecoind: Install: FATAL:
fn_script_log_fatal() {
  if [ -d "${log_dir}" ]; then
    if [ -n "${command_name}" ]; then
      echo -e "$(date '+%b %d %H:%M:%S.%3N') ${self_name}: ${command_name}: FATAL: ${1}" >>"${daemon_logs}"
    else
      echo -e "$(date '+%b %d %H:%M:%S.%3N') ${self_name}: FATAL: ${1}" >>"${daemon_logs}"
    fi
  fi
  exitcode=1
}

## Jan 26 01:37:20 litecoind: Install: ERROR:
fn_script_log_error() {
  if [ -d "${log_dir}" ]; then
    if [ -n "${command_name}" ]; then
      echo -e "$(date '+%b %d %H:%M:%S.%3N') ${self_name}: ${command_name}: ERROR: ${1}" >>"${daemon_logs}"
    else
      echo -e "$(date '+%b %d %H:%M:%S.%3N') ${self_name}: ERROR: ${1}" >>"${daemon_logs}"
    fi
  fi
  exitcode=2
}

## Jan 26 01:37:20 litecoind: Install: WARN:
fn_script_log_warn() {
  if [ -d "${log_dir}" ]; then
    if [ -n "${command_name}" ]; then
      echo -e "$(date '+%b %d %H:%M:%S.%3N') ${self_name}: ${command_name}: WARN: ${1}" >>"${daemon_logs}"
    else
      echo -e "$(date '+%b %d %H:%M:%S.%3N') ${self_name}: WARN: ${1}" >>"${daemon_logs}"
    fi
  fi
  exitcode=3
}

## Jan 26 01:37:20 litecoind: Install: INFO:
fn_script_log_info() {
  if [ -d "${log_dir}" ]; then
    if [ -n "${command_name}" ]; then
      echo -e "$(date '+%b %d %H:%M:%S.%3N') ${self_name}: ${command_name}: INFO: ${1}" >>"${daemon_logs}"
    else
      echo -e "$(date '+%b %d %H:%M:%S.%3N') ${self_name}: INFO: ${1}" >>"${daemon_logs}"
    fi
  fi
}

# On-Screen automated functions

# [ .... ]
fn_print_dots() {
  if [ -n "${command_name}" ]; then
    echo -en "${creeol}[ .... ] ${command_name} ${self_name}: $*"
  else
    echo -en "${creeol}[ .... ] $*"
  fi
  fn_sleep_time
}

fn_print_dots_nl() {
  if [ -n "${command_name}" ]; then
    echo -en "${creeol}[ .... ] ${command_name} ${self_name}: $*"
  else
    echo -en "${creeol}[ .... ] $*"
  fi
  fn_sleep_time
  echo -en "\n"
}

# [ OK ]
fn_print_ok() {
  if [ -n "${command_name}" ]; then
    echo -en "${creeol}[${green} OK ${default}] ${command_name} ${self_name}: $*"
  else
    echo -en "${creeol}[${green} OK ${default}] $*"
  fi
  fn_sleep_time
}

# [ OK ]
fn_print_ok_nl() {
  if [ -n "${command_name}" ]; then
    echo -en "${creeol}[${green} OK ${default}] ${command_name} ${self_name}: $*"
  else
    echo -en "${creeol}[${green} OK ${default}] $*"
  fi
  fn_sleep_time
  echo -en "\n"
}

# [ FAIL ]
fn_print_fail() {
  if [ -n "${command_name}" ]; then
    echo -en "${creeol}[${red} FAIL ${default}] ${command_name} ${self_name}: $*"
  else
    echo -en "${creeol}[${red} FAIL ${default}] $*"
  fi
  fn_sleep_time
}

# [ FAIL ]
fn_print_fail_nl() {
  if [ -n "${command_name}" ]; then
    echo -en "${creeol}[${red} FAIL ${default}] ${command_name} ${self_name}: $*"
  else
    echo -en "${creeol}[${red} FAIL ${default}] $*"
  fi
  fn_sleep_time
  echo -en "\n"
}

# [ ERROR ]
fn_print_error() {
  if [ -n "${command_name}" ]; then
    echo -en "${creeol}[${red} ERROR ${default}] ${command_name} ${self_name}: $*"
  else
    echo -en "${creeol}[${red} ERROR ${default}] $*"
  fi
  fn_sleep_time
}

# [ ERROR ]
fn_print_error_nl() {
  if [ -n "${command_name}" ]; then
    echo -en "${creeol}[${red} ERROR ${default}] ${command_name} ${self_name}: $*"
  else
    echo -e "${creeol}[${red} ERROR ${default}] $*"
  fi
  fn_sleep_time
  echo -en "\n"
}

# [ WARN ]
fn_print_warn() {
  if [ -n "${command_name}" ]; then
    echo -en "${creeol}[${red} WARN ${default}] ${command_name} ${self_name}: $*"
  else
    echo -en "${creeol}[${red} WARN ${default}] $*"
  fi
  fn_sleep_time
}

# [ WARN ]
fn_print_warn_nl() {
  if [ -n "${command_name}" ]; then
    echo -en "${creeol}[${lightyellow} WARN ${default}] ${command_name} ${self_name}: $*"
  else
    echo -e "${creeol}[${lightyellow} WARN ${default}] $*"
  fi
  fn_sleep_time
  echo -en "\n"
}

# [ INFO ]
fn_print_info() {
  if [ -n "${command_name}" ]; then
    echo -en "${creeol}[${cyan} INFO ${default}] ${command_name} ${self_name}: $*"
  else
    echo -en "${creeol}[${cyan} INFO ${default}] $*"
  fi
  fn_sleep_time
}

# [ INFO ]
fn_print_info_nl() {
  if [ -n "${command_name}" ]; then
    echo -en "${creeol}[${cyan} INFO ${default}] ${command_name} ${self_name}: $*"
  else
    echo -e "${creeol}[${cyan} INFO ${default}] $*"
  fi
  fn_sleep_time
  echo -en "\n"
}

# On-Screen interactive messages

# No more Room in hell
# ====================
fn_print_header() {
  echo -e ""
  echo -e "${lightyellow}${daemon_name} ${command_action}${default}"
  echo -e "=====================================${default}"
}

# Complete!
fn_print_complete() {
  echo -en "${green}Complete!${default} $*"
  fn_sleep_time
}

# Complete!
fn_print_complete_nl() {
  echo -e "${green}Complete!${default} $*"
  fn_sleep_time
}

# Failure!
fn_print_failure() {
  echo -en "${red}Failure!${default} $*"
  fn_sleep_time
}

# Failure!
fn_print_failure_nl() {
  echo -e "${red}Failure!${default} $*"
  fn_sleep_time
}

# Error!
fn_print_error2() {
  echo -en "${red}Error!${default} $*"
  fn_sleep_time
}

# Error!
fn_print_error2_nl() {
  echo -e "${red}Error!${default} $*"
  fn_sleep_time
}

# Warning!
fn_print_warning() {
  echo -en "${lighyellow}Warning!${default} $*"
  fn_sleep_time
}

# Warning!
fn_print_warning_nl() {
  echo -e "${lighyellow}Warning!${default} $*"
  fn_sleep_time
}

# Information!
fn_print_information() {
  echo -en "${cyan}Information!${default} $*"
  fn_sleep_time
}

# Information!
fn_print_information_nl() {
  echo -e "${cyan}Information!${default} $*"
  fn_sleep_time
}

# Y/N prompt
fn_prompt_yn() {
  local prompt="$1"
  local intial="$2"

  if [ "${intial}" == "Y" ]; then
    prompt+=" [Y/n] "
  elif [ "${initial}" == "N" ]; then
    prompt+=" [y/N] "
  else
    prompt+=" [y/n] "
  fi

  while true; do
    read -e -i "${initial}" -p "${prompt}" -r yn
    case "${yn}" in
    [Yy] | [Yy][Ee][Ss]) return 0 ;;
    [Nn] | [Nn][Oo]) return 1 ;;
    *) echo -e "Please answer yes or no" ;;
    esac
  done
}

# On-Screen End of line

# OK
fn_print_ok_eol() {
  echo -en "${green}OK${default}"
}

# OK
fn_print_ok_eol_nl() {
  echo -e "${green}OK${default}"
}

# FAIL
fn_print_fail_eol() {
  echo -en "${red}FAIL${default}"
}

# FAIL
fn_print_fail_eol_nl() {
  echo -e "${red}FAIL${default}"
}

# ERROR
fn_print_error_eol() {
  echo -en "${red}ERROR${default}"
}

# ERROR
fn_print_error_eol_nl() {
  echo -e "${red}ERROR${default}"
}

# WARN
fn_print_warn_eol() {
  echo -en "${lightyellow}WARN${default}"
}

# WARN
fn_print_warn_eol_nl() {
  echo -e "${lightyellow}WARN${default}"
}

# INFO
fn_print_info_eol() {
  echo -en "${cyan}INFO${default}"
}

# INFO
fn_print_info_eol_nl() {
  echo -e "${cyan}INFO${default}"
}

# QUERYING
fn_print_querying_eol() {
  echo -en "${cyan}QUERYING${default}"
}

# QUERYING
fn_print_quering_eol_nl() {
  echo -e "${cyan}QUERYING${default}"
}

# CHECKING
fn_print_checking_eol() {
  echo -en "${cyan}CHECKING${default}"
}

# CHECKING
fn_print_checking_eol_nl() {
  echo -e "${cyan}CHECKING${default}"
}

# DELAY
fn_print_delay_eol() {
  echo -en "${green}DELAY${default}"
}

# DELAY
fn_print_delay_eol_nl() {
  echo -e "${green}DELAY${default}"
}

# CANCELED
fn_print_canceled_eol() {
  echo -en "${yellow}CANCELED${default}"
}

# CANCELED
fn_print_canceled_eol_nl() {
  echo -e "${yellow}CANCELED${default}"
}

# REMOVED
fn_print_removed_eol() {
  echo -en "${red}REMOVED${default}"
}

# REMOVED
fn_print_removed_eol_nl() {
  echo -e "${red}REMOVED${default}"
}

# UPDATE
fn_print_update_eol() {
  echo -en "${cyan}UPDATE${default}"
}

# UPDATE
fn_print_update_eol_nl() {
  echo -e "${cyan}UPDATE${default}"
}

# LOGO
fn_print_ascii_logo() {
  echo -e ""
  echo -e " /$$   /$$                                 /$$                               /$$$$$$$$"
  echo -e "| $$  /$$/                                | $$                              |__  $$__/ "
  echo -e "| $$ /$$/   /$$$$$$  /$$   /$$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$         | $$  /$$$$$$   /$$$$$$  /$$$$$$/$$$$"
  echo -e "| $$$$$/   /$$__  $$| $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/         | $$ /$$__  $$ |____  $$| $$_  $$_  $$"
  echo -e "| $$  $$  | $$  \__/| $$  | $$| $$  \ $$  | $$    | $$  \ $$|  $$$$$$          | $$| $$$$$$$$  /$$$$$$$| $$ \ $$ \ $$"
  echo -e "| $$\  $$ | $$      | $$  | $$| $$  | $$  | $$ /$$| $$  | $$ \____  $$         | $$| $$_____/ /$$__  $$| $$ | $$ | $$"
  echo -e "| $$ \  $$| $$      |  $$$$$$$| $$$$$$$/  |  $$$$/|  $$$$$$/ /$$$$$$$/         | $$|  $$$$$$$|  $$$$$$$| $$ | $$ | $$"
  echo -e "|__/  \__/|__/       \____  $$| $$____/    \___/   \______/ |_______/          |__/ \_______/ \_______/|__/ |__/ |__/"
  echo -e "                     /$$  | $$| $$                                                                                   "
  echo -e "                    |  $$$$$$/| $$                                                                                   "
  echo -e "                     \______/ |__/                                                                                   "
  echo -e ""
}

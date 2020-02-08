#!/usr/bin/env bash

# Debugging
if [ -f ".debug" ]; then
  exec 5>debug.log
  BASH_XTRACEFD="5"
  set -x
fi

version="v1.0.0"
short_name="core"
daemon_name="core"
root_dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")
lock_selfname=".${self_name}.lock"
daemon_dir="${root_dir}/daemon"
functions_dir="${daemon_dir}/functions"
data_dir="${daemon_dir}/data"
daemon_list="${data_dir}/daemon_list.csv"
daemon_list_menu="${data_dir}/daemon_list_menu.csv"
daemon_files="${root_dir}/${short_name}"
log_dir="${daemon_files}/logs"
daemon_logs="${log_dir}/${daemon_name}.log"
tmp_dir="${daemon_files}/tmp"
daemon_cfg_dir="${daemon_files}/config"
daemon_config_file="${daemon_cfg_dir}/coin.conf"
daemon_installed="${daemon_files}/.installed"
default_config_dir="${daemon_dir}/configurations"

user_input="${1}"

## Github Values
githubuser="Kryptos-Team"
githubrepo="daemon"
githubbranch="master"

# Core function that is required first
core_functions.sh() {
  function_file="${FUNCNAME[0]}"
  fn_bootstrap_fetch_file_github "daemon/functions" "core_functions.sh" "${functions_dir}" "chmodx" "run" "noforcedl" "nomd5"
}

# Bootstrap
# Fetches the core functions before passed off to core_dl.sh
fn_bootstrap_fetch_file() {
  remote_file_url="${1}"
  local_file_dir="${2}"
  local_file_name="${3}"
  chmodx="${4:-0}"
  run="${5:-0}"
  forcedl="${6:-0}"
  md5="${7:-0}"
  # Download file if missing or download forced
  if [ ! -f "${local_file_dir}/${local_file_name}" ] || [ "${forcedl}" == "forcedl" ]; then
    if [ ! -d "${local_file_dir}" ]; then
      mkdir -p "${local_file_dir}"
    fi

    # If curl exists, download file
    if [ -n "$(command -v curl 2>/dev/null)" ]; then
      echo -en "fetching ${local_file_name}...\c"
      curlcmd=$(curl -s --fail -L -o "${local_file_dir}/${local_file_name}" "${remote_file_url}" 2>&1)
      local exitcode=$?
      if [ ${exitcode} -ne 0 ]; then
        echo -e "FAIL"
        if [ -f "${daemon_logs}" ]; then
          echo -e "${remote_file_url}" | tee -a "${daemon_logs}"
          echo -e "${curlcmd}" | tee -a "${daemon_logs}"
        fi
        exit 1
      else
        echo -e "OK"
      fi
    else
      echo -e "[ FAIL ] Curl is not installed"
      exit 1
    fi
    # Make file chmodx if chmodx is set
    if [ "${chmodx}" == "chmodx" ]; then
      chmod +x "${local_file_dir}/${local_file_name}"
    fi
  fi

  if [ -f "${local_file_dir}/${local_file_name}" ]; then
    # Run file if run is set
    if [ "${run}" == "run" ]; then
      source "${local_file_dir}/${local_file_name}"
    fi
  fi
}

fn_bootstrap_fetch_file_github() {
  github_file_url_dir="${1}"
  github_file_url_name="${2}"
  github_url="https://raw.githubusercontent.com/${githubuser}/${githubrepo}/${githubbranch}/${github_file_url_dir}/${github_file_url_name}"

  remote_file_url="${github_url}"
  local_file_dir="${3}"
  local_file_name="${github_file_url_name}"
  chmodx="${4:-0}"
  run="${5:-0}"
  forcedl="${6:-0}"
  md5="${7:-0}"
  # Passes variables to the file download function
  fn_bootstrap_fetch_file "${remote_file_url}" "${local_file_dir}" "${local_file_name}" "${chmodx}" "${run}" "${forcedl}" "${md5}"
}

# Installer menu

fn_print_center() {
  columns=$(tput cols)
  line="$*"
  printf "%*s\n" $(((${#line} + columns) / 2)) "${line}"
}

fn_print_horizontal() {
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "="
}

fn_install_menu_bash() {
  local resultvar=$1
  title=$2
  caption=$3
  options=$4
  fn_print_horizontal
  fn_print_center "${title}"
  fn_print_center "${caption}"
  fn_print_horizontal
  menu_options=()

  while read -r line || [[ -n "${line}" ]]; do
    var=$(echo -e "${line}" | awk -F "," '{print $1 " - " $2}')
    menu_options+=("${var}")
  done <"${options}"
  menu_options+=("Cancel")
  select option in "${menu_options[@]}"; do
    if [ -n "${option}" ] && [ "${option}" != "Cancel" ]; then
      eval "$resultvar=\"${option/%\ */}\""
    fi
    break
  done
}

fn_install_menu_whiptail() {
  local menucmd=$1
  local resultvar=$2
  title=$3
  caption=$4
  options=$5
  height=${6:-40}
  width=${7:-80}
  menuheight=${8:-30}
  IFS=","
  menu_options=()
  while read -r line; do
    key=$(echo -e "${line}" | awk -F "," '{print $2}')
    val=$(echo -e "${line}" | awk -F "," '{print $1}')
    menu_options+=("${val//\"/}" "${key//\"/}")
  done <"${options}"
  OPTION=$(${menucmd} --title "${title}" --menu "${caption}" "${height}" "${width}" "${menuheight}" "${menu_options[@]}" 3>&1 1>&2 2>&3)
  if [ $? == 0 ]; then
    eval "$resultvar=\"${OPTION}\""
  else
    eval "$resultvar="
  fi
}

# Menu selector
fn_install_menu() {
  local resultvar=$1
  local selection=""
  title=$2
  caption=$3
  options=$4
  # Get menu command
  for menucmd in whiptail dialog bash; do
    if [ -x "$(command -v "${menucmd}")" ]; then
      menucmd=$(command -v "${menucmd}")
      break
    fi
  done
  case "$(basename "${menucmd}")" in
  whiptail | dialog)
    fn_install_menu_whiptail "${menucmd}" selection "${title}" "${caption}" "${options}" 40 80 30
    ;;
  *)
    fn_install_menu_bash selection "${title}" "${caption}" "${options}"
    ;;
  esac
  eval "$resultvar=\"${selection}\""
}

# Gets server info from daemon_list.csv and puts into array
fn_daemon_info() {
  IFS=","
  daemon_info_array=($(grep -aw "$user_input" "${daemon_list}"))
  short_name="${daemon_info_array[1]}"       # LTC
  daemon_name="${daemon_info_array[0]}"      # litecoind
  daemon_full_name="${daemon_info_array[2]}" # Litecoin
  daemon_version="${daemon_info_array[3]}"   # 0.17.1
}

fn_install_getopt() {
  user_input="empty"
  echo -e "Usage: $0 [option]"
  echo -e ""
  echo -e "Installer - Kryptos Coin Daemon - Version ${version}"
  echo -e "https://github.com/Kryptos-Team"
  echo -e ""
  echo -e "Commands"
  echo -e "install\t\t| Select daemon to install"
  echo -e "coin_name\t| Enter coin name daemon to install. e.g $0 litecoind"
  echo -e "list\t\t| List all coin daemons available to install"
  exit
}

fn_install_file() {
  local_file_name="${daemon_name}"
  if [ -e "${local_file_name}" ]; then
    i=2
    while [ -e "$local_file_name-${i}" ]; do
      ((i++))
    done
    local_file_name="${local_file_name}-${i}"
  fi
  cp -R "${self_name}" "${local_file_name}"
  sed -i -e "s/short_name=\"core\"/short_name=\"${short_name}\"/g" "${local_file_name}"
  sed -i -e "s/daemon_name=\"core\"/daemon_name=\"${daemon_name}\"/g" "${local_file_name}"
  echo -e "Installed ${daemon_name} daemon as ${local_file_name}"
  echo -e ""
  if [ ! -d "${daemon_files}" ]; then
    echo -e "./${local_file_name} install"
  else
    echo -e "Remember to check daemon ports"
    echo -e "./${local_file_name} details"
  fi
  echo -e ""
  exit
}

# Prevents install.sh to run as root, except if doing a dependency install
if [ "$(whoami)" == "root" ]; then
  if [ "${user_input}" == "install" ]; then
    echo -e "[ FAIL ] Do NOT run this script as root!"
    exit 1
  elif [ ! -f "${functions_dir/core_messages.sh}" ]; then
    echo -e "[ FAIL ] Do NOT run this script as root!"
    exit 1
  else
    core_functions.sh
    check_root.sh
  fi
fi

# Kryptos Installer mode
if [ "${short_name}" == "core" ]; then
  # Download the latest daemon list. This is the list of all supported daemons
  fn_bootstrap_fetch_file_github "daemon/data" "daemon_list.csv" "${data_dir}" "nochmodx" "norun" "forcedl" "nomd5"
  if [ ! -f "${daemon_list}" ]; then
    echo -e "[ FAIL ] daemon_list.csv could not be loaded"
    exit 1
  fi

  if [ "${user_input}" == "list" ] || [ "${user_input}" == "l" ]; then
    {
      tail -n +1 "${daemon_list}" | awk -F "," '{print $1 "\t" $2 "\t" $3 "\t" $4}'
    } | column -s $'\t' -t | more
    exit
  elif [ "${user_input}" == "install" ] || [ "${user_input}" == "i" ]; then
    tail -n +2 "${daemon_list}" | awk -F "," '{print $1 "," $2 "," $3 "," $4}' >"${daemon_list_menu}"
    fn_install_menu result "Kryptos Team" "Select coin daemon name to install" "${daemon_list_menu}"
    user_input="${result}"
    fn_daemon_info
    if [ "${result}" == "${daemon_name}" ]; then
      fn_install_file
    elif [ "${result}" == "" ]; then
      echo -e "Install cancelled"
    else
      echo -e "[ FAIL ] menu result does not match daemon name"
      echo -e "result: ${result}"
      echo -e "daemon name: ${daemon_name}"
    fi
  elif [ -n "${user_input}" ]; then
    fn_daemon_info
    if [ "${user_input}" == "${daemon_name}" ] || [ "${user_input}" == "${short_name}" ]; then
      fn_install_file
    else
      echo -e "[ FAIL ] unknown daemon name"
    fi
  else
    fn_install_getopt
  fi
# Daemon mode
else
  core_functions.sh
  fn_ansi_loader
  getopt=$1
  core_getopt.sh
fi

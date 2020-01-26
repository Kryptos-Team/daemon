#!/usr/bin/env bash
# Description: Deals with downloads of daemon

# remote_file_url: The URL of the file
# local_file_dir: Location of the file is to be saved
# local_file_name: Name of the file
# chmodx: Optional, set to "chmodx" to make files executable using chmod +x
# run: Optional, set run to execue the file after download
# forcedl: Optional, force re-download of file even if it exists
# md5: Optional, set an md5 sum and will compare it against the file

local command_name="DOWNLOAD"
local command_action="Download"
local function_self_name="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")"

fn_clear_tmp() {
  echo -en "Clearing Daemon tmp directory"
  if [ -d "${tmp_dir}" ]; then
    rm -rf "${tmp_dir:?}/*"
    local exitcode=$?
    if [ "${exitcode}" -eq 0 ]; then
      fn_print_ok_eol_nl
      fn_script_log_pass "clearing daemon tmp directory"
    else
      fn_print_error_eol_nl
      fn_script_log_error "clearing daemon tmp directory"
    fi
  fi
}

fn_dl_md5() {
  # Runs MD5 checksum if available
  if [ "${md5}" != "0" ] && [ "${md5}" != "nomd5" ]; then
    echo -en "verifying ${local_file_name} with MD5..."
    fn_sleep_time
    local md5sumcmd=$(md5sum "${local_file_dir}/${local_file_name}" | awk '{print $1;}')
    if [ "${md5sumcmd}" != "${md5}" ]; then
      fn_print_fail_eol_nl
      echo -e "${local_file_name} returned MD5 checksum: ${md5sumcmd}"
      echo -e "expected MD5 checksum: ${md5}"
      fn_script_log_fatal "Verifying ${local_file_name} with MD5"
      fn_script_log_info "${local_file_name} returned MD5 checksum: ${md5sumcmd}"
      fn_script_log_info "Expected MD5 checksum: ${md5}"
      core_exit.sh
    else
      fn_print_ok_eol_nl
      fn_script_log_pass "Verifying ${local_file_name} with MD5"
      fn_script_log_info "${local_file_name} returned MD5 checksum: ${md5sumcmd}"
      fn_script_log_info "Expected MD5 checksum: ${md5}"
    fi
  fi
}

fn_dl_extract() {
  local_file_dir="${1}"
  local_file_name="${2}"
  extract_dir="${3}"
  # Extracts archives
  echo -en "extracting ${local_file_name}..."
  mime=$(file -b --mime-type "${local_file_dir}/${local_file_name}")
  if [ ! -d "${extract_dir}" ]; then
    mkdir "${extract_dir}"
  fi
  if [ "${mime}" == "application/gzip" ] || [ "${mime}" == "application/x-gzip" ]; then
    extractcmd=$(tar -zxf "${local_file_dir}/${local_file_name}" -C "${extract_dir}")
  elif [ "${mime}" == "application/x-bzip2" ]; then
    extractcmd=$(tar -jxf "${local_file_dir}/${local_file_name}"-C "${extract_dir}")
  elif [ "${mime}" == "application/x-xz" ]; then
    extractcmd=$(tar -xf "${local_file_dir}/${local_file_name}"-C "${extract_dir}")
  elif [ "${mime}" == "application/zip" ] || [ "${mime}" == "application/x-zip" ]; then
    extractcmd=$(unzip -qo -d "${extract_dir}" "${local_file_dir}/${local_file_name}")
  fi
  local exitcode=$?
  if [ "${exitcode}" -ne 0 ]; then
    fn_print_fail_eol_nl
    fn_script_log_fatal "Extracting download"
    if [ -f "${daemon_logs}" ]; then
      echo -e "${extractcmd}" >>"${daemon_logs}"
    fi
    echo -e "${extractcmd}"
    core_exit.sh
  else
    fn_print_ok_eol_nl
    fn_script_log_pass "Extracting download"
  fi
}

# Trap to remove file download if cancelled before completed
fn_fetch_trap() {
  echo -e ""
  echo -en "downloading ${local_file_name}..."
  fn_print_cancelled_eol_nl
  fn_script_log_info "Downloading ${local_file_name}... CANCELLED"
  fn_sleep_time
  rm -f "${local_file_dir}/${local_file_name}"
  echo -en "downloading ${local_file_name}"
  fn_print_removed_eol_nl
  fn_script_log_info "Downloading ${local_file_name}...REMOVED"
  core_exit.sh
}

fn_fetch_file() {
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
    # Trap will remove part download files if cancelled
    trap fn_fetch_trap INT
    # Larger files show a progress bar
    if [ "${local_file_name##*.}" == "bz2" ] || [ "${local_file_name##*.}" == "gz" ] || [ "${local_file_name##*.}" == "zip" ] || [ "${local_file_name##*.}" == "xz" ]; then
      echo -en "downloading ${local_file_name}..."
      fn_sleep_time
      echo -en "\033[1K"
      curlcmd=$(curl --progress-bar --fail -L -o "${local_file_dir}/${local_file_name}" "${remote_file_url}")
      echo -en "downloading ${local_file_name}..."
    else
      echo -en "fetching ${local_file_name}..."
      curlcmd=$(curl -s --fail -L -o "${local_file_dir}/${local_file_name}" "${remote_file_url}" 2>&1)
    fi
    local exitcode=$?
    if [ "${exitcode}" -ne 0 ]; then
      fn_print_fail_eol_nl
      if [ -f "${daemon_logs}" ]; then
        fn_script_log_fatal "Downloading ${local_file_name}"
        echo -e "${remote_file_url}" >>"${daemon_logs}"
        echo -e "${curlcmd}" >>"${daemon_logs}"
      fi
      echo -e "${remote_file_url}"
      echo -e "${curlcmd}"
      core_exit.sh
    else
      fn_print_ok_eol_nl
      if [ -f "${daemon_logs}" ]; then
        fn_script_log_pass "Downloading ${local_file_name}"
      fi
    fi
    # Remove trap
    trap - INT
    # Make file executable if chmddx is set
    if [ "${chmodx}" == "chmodx" ]; then
      chmod +x "${local_file_dir}/${local_file_name}"
    fi
  fi

  if [ -f "${local_file_dir}/${local_file_name}" ]; then
    fn_dl_md5
    # Execute file is run is set
    if [ "${run}" == "run" ]; then
      source "${local_file_dir}/${local_file_name}"
    fi
  fi
}

fn_fetch_file_github() {
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
  fn_fetch_file "${remote_file_url}" "${local_file_dir}" "${local_file_name}" "${chmodx}" "${run}" "${forcedl}" "${md5}"
}

fn_fetch_config() {
  github_file_url_dir="${1}"
  github_file_url_name="${2}"
  github_url="https://raw.githubusercontent.com/${githubuser}/${githubrepo}/${githubbranch}/${github_file_url_dir}/${github_file_url_name}"

  remote_file_url="${github_url}"
  local_file_dir="${3}"
  local_file_name="${4}"
  chmodx="nochmodx"
  run="norun"
  forcedl="noforce"
  md5="nomd5"
  fn_fetch_file "${remote_file_url}" "${local_file_dir}" "${local_file_name}" "${chmodx}" "${run}" "${forcedl}" "${md5}"
}

fn_fetch_function() {
  github_file_url_dir="daemon/functions"
  github_file_url_name="${function_file}"
  github_url="https://raw.githubusercontent.com/${githubuser}/${githubrepo}/${githubbranch}/${github_file_url_dir}/${github_file_url_name}"

  remote_file_url="${github_url}"
  local_file_dir="${functions_dir}"
  local_file_name="${github_file_url_name}"
  chmodx="chmodx"
  run="run"
  forcedl="noforce"
  md5="nomd5"
  fn_fetch_file "${remote_file_url}" "${local_file_dir}" "${local_file_name}" "${chmodx}" "${run}" "${forcedl}" "${md5}"
}

fn_update_function() {
  exitbypass=1
  github_file_url_dir="daemon/functions"
  github_file_url_name="${function_file}"
  github_url="https://raw.githubusercontent.com/${githubuser}/${githubrepo}/${githubbranch}/${github_file_url_dir}/${github_file_url_name}"

  remote_file_url="${github_url}"
  local_file_dir="${functions_dir}"
  local_file_name="${github_file_url_name}"
  chmodx="chmodx"
  run="norun"
  forcedl="noforce"
  md5="nomd5"
  fn_fetch_file "${remote_file_url}" "${local_file_dir}" "${local_file_name}" "${chmodx}" "${run}" "${forcedl}" "${md5}"
}

# Check that curl is installed
if [ -z "$(command -v curl 2>/dev//null)" ]; then
  echo -e "[ FAIL ] curl is not installed"
  exit 1
fi

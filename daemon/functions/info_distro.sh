#!/usr/bin/env bash

local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

### Distro information

## Distro
# Returns architecture, kernel and distro/os
arch=$(uname -m)
kernel=$(uname -r)

# Gathers distro information
distro_info_array=(os-release lsb_release hostnamectl debian_version redhat-release)
for distro_info in "${distro_info_array[@]}"; do
  if [ -f "/etc/os-release" ] && [ "${distro_info}" == "os-release" ]; then
    distro_name=$(grep PRETTY_NAME /etc/os-release | sed 's/PRETTY_NAME=//g' | tr -d '="' | sed 's/\"//g')
    distro_version=$(grep VERSION_ID /etc/os-release | sed 's/VERSION_ID=//g' | sed 's/\"//g')
    distro_id=$(grep ID /etc/os-release | grep -v _ID | grep -v ID_ | sed 's/ID=//g' | sed 's/\"//g')
    distro_code_name=$(grep VERSION_CODENAME /etc/os-release | sed 's/VERSION_CODENAME=//g' | sed 's/\"//g')
  elif [ -n "$(command -v lsb_release 2>/dev/null)" ] && [ "${distro_info}" == "lsb_release" ]; then
    if [ -z "${distro_name}" ]; then
      distro_name="$(lsb_release -sd)"
    fi
    if [ -z "${distro_version}" ]; then
      distro_version="$(lsb_release -sr)"
    fi
    if [ -z "${distro_id}" ]; then
      distro_id="$(lsb_release -si)"
    fi
    if [ -z "${distro_code_name}" ]; then
      distro_code_name="$(lsb_release -sc)"
    fi
  elif [ -n "$(command -v hostnamectl 2>/dev/null)" ] && [ "${distro_info}" == "hostnamectl" ]; then
    if [ -z "${distro_name}" ]; then
      distro_name="Debian $(cat /etc/debian_version)"
    fi
    if [ -z "${distro_version}" ]; then
      distro_version="$(cat /etc/debian_version)"
    fi
    if [ -z "${distro_id}" ]; then
      distro_id="debian"
    fi
  elif [ -f "/etc/redhat-release" ] && [ "${distro_info}" == "redhat-release" ]; then
    if [ -z "${distro_name}" ]; then
      distro_name="$(cat /etc/redhat-release)"
    fi
    if [ -z "${distro_version}" ]; then
      distro_version="$(rpm -qa \*-release | grep -Ei "oracle|redhat|centos|fedora" | cut -d"-" -f3)"
    fi
    if [ -z "${distro_id}" ]; then
      distro_id="$(awk '{print $1}' /etc/redhat-release)"
    fi
  fi
done

## Glibc version
# e.g: 1.17
glibc_version=$(ldd --version | sed -n '1s/.* //p')

## tmux version
# e.g: tmux 1.6
if [ -z "$(command -V tmux 2>/dev/null)" ]; then
  tmux_version="${red}NOT INSTALLED!${default}"
else
  if [ "$(tmux -V | sed "s/tmux //" | sed -n '1 p' | tr -cd '[:digit:]')" -lt "16" ]; then
    tmux_version="$(tmux -V) (>= 1.6 required for console log)"
  else
    tmux_version="$(tmux -V)"
  fi
fi

## Uptime
uptime="$(</proc/uptime)"
uptime="${uptime/[. ]*/}"
minutes="$((uptime / 60 % 60))"
hours="$((uptime / 60 / 60 % 24))"
days="$((uptime / 60 / 60 / 24))"

### Performance Information

## Average server load
load="$(uptime | awk -F 'load average: ' '{ print $2 }')"

## CPU Information
cpu_model="$(awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//')"
cpu_cores="$(awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo)"
cpu_frequency="$(awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//')"

## Memory Information
# Available RAM and swap

# Newer distro can use numfmt to give more accurate information
if [ -n "$(command -v numfmt 2>/dev/null)" ]; then
  # get raw KB values
  phys_mem_total_kb="$(grep MemTotal /proc/meminfo | awk '{print $2}')"
  phys_mem_free_kb="$(grep ^MemFree /proc/meminfo | awk '{print $2}')"
  phys_mem_buffers_kb="$(grep ^Buffers /proc/meminfo | awk '{print $2}')"
  phys_mem_cached_kb="$(grep ^Cached /proc/meminfo | awk '{print $2}')"
  phys_mem_reclaimable_kb="$(grep ^Reclaimable /proc/meminfo | awk '{print $2}')"

  # Check if MemAvailable exists
  if grep -q ^MemAvailable /proc/meminfo; then
    phys_mem_actual_free_kb="$(grep ^MemAvailable /proc/meminfo | awk '{print $2}')"
  else
    phys_mem_actual_free_kb="$((phys_mem_free_kb + phys_mem_buffers_kb + phys_mem_cache_kb))"
  fi

  # Available RAM and swap
  # Available RAM and swap.
  phys_mem_total_mb=$((phys_mem_total_kb / 1024))
  phys_mem_total=$(numfmt --to=iec --from=iec --suffix=B "${phys_mem_total_kb}K")
  phys_mem_free=$(numfmt --to=iec --from=iec --suffix=B "${phys_mem_actual_free_kb}K")
  phys_mem_used=$(numfmt --to=iec --from=iec --suffix=B "$((phys_mem_total_kb - phys_mem_free_kb - phys_mem_buffers_kb - phys_mem_cached_kb - phys_mem_reclaimable_kb))K")
  phys_mem_available=$(numfmt --to=iec --from=iec --suffix=B "${phys_mem_actual_free_kb}K")
  phys_mem_cached=$(numfmt --to=iec --from=iec --suffix=B "$((phys_mem_cached_kb + phys_mem_reclaimable_kb))K")

  swap_total=$(numfmt --to=iec --from=iec --suffix=B "$(grep ^SwapTotal /proc/meminfo | awk '{print $2}')K")
  swap_free=$(numfmt --to=iec --from=iec --suffix=B "$(grep ^SwapFree /proc/meminfo | awk '{print $2}')K")
  swap_used=$(numfmt --to=iec --from=iec --suffix=B "$(($(grep ^SwapTotal /proc/meminfo | awk '{print $2}') - $(grep ^SwapFree /proc/meminfo | awk '{print $2}')))K")
else
  # Older distros will need to use free.
  # Older versions of free do not support -h option.
  if [ "$(
    free -h >/dev/null 2>&1
    echo $?
  )" -ne "0" ]; then
    human_readable="-m"
  else
    human_readable="-h"
  fi
  phys_mem_total_mb=$(free -m | awk '/Mem:/ {print $2}')
  phys_mem_total=$(free ${human_readable} | awk '/Mem:/ {print $2}')
  phys_mem_free=$(free ${human_readable} | awk '/Mem:/ {print $4}')
  phys_mem_used=$(free ${human_readable} | awk '/Mem:/ {print $3}')

  oldfree=$(free ${human_readable} | awk '/cache:/')
  if [ -n "${oldfree}" ]; then
    phys_mem_available="n/a"
    phys_mem_cached="n/a"
  else
    phys_mem_available=$(free ${human_readable} | awk '/Mem:/ {print $7}')
    phys_mem_cached=$(free ${human_readable} | awk '/Mem:/ {print $6}')
  fi

  swap_total=$(free ${human_readable} | awk '/Swap:/ {print $2}')
  swap_used=$(free ${human_readable} | awk '/Swap:/ {print $3}')
  swap_free=$(free ${human_readable} | awk '/Swap:/ {print $4}')
fi

### Disk Information

## Available disk space on the partition.
file_system=$(df -hP "${root_dir}" | grep -v "Filesystem" | awk '{print $1}')
total_space=$(df -hP "${root_dir}" | grep -v "Filesystem" | awk '{print $2}')
used_space=$(df -hP "${root_dir}" | grep -v "Filesystem" | awk '{print $3}')
avail_space=$(df -hP "${root_dir}" | grep -v "Filesystem" | awk '{print $4}')

# Network Interface name
net_int=$(ip -o addr | grep "${ip}" | awk '{print $2}')
net_link=$(ethtool "${net_int}" 2>/dev/null | grep Speed | awk '{print $2}')

# External IP address
if [ -z "${ext_ip}" ]; then
	ext_ip=$(curl -4 -m 3 ifconfig.co 2>/dev/null)
	exitcode=$?
	# Should ifconfig.co return an error will use last known IP.
	if [ ${exitcode} -eq 0 ]; then
		echo -e "${ext_ip}" > "${tmp_dir}/ext_ip.txt"
	else
		if [ -f "${tmp_dir}/ext_ip.txt" ]; then
			ext_ip=$(cat "${tmp_dir}/ext_ip.txt")
		else
			echo -e "x.x.x.x"
		fi
	fi
fi
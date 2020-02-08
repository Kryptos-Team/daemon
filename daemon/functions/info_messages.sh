#!/usr/bin/env bash

fn_info_message_head() {
  echo -e ""
  echo -e "${lightyellow}Summary${default}"
  fn_messages_separator
  echo -e "Message"
  echo -e "${alertbody}"
  echo -e ""
  echo -e "Game"
  echo -e "${gamename}"
  echo -e ""
  echo -e "Server name"
  echo -e "${servername}"
  echo -e ""
  echo -e "Hostname"
  echo -e "${HOSTNAME}"
  echo -e ""
  echo -e "Server IP"
  if [ "${multiple_ip}" == "1" ]; then
    echo -e "NOT SET"
  else
    echo -e "${ip}:${port}"
  fi
}

fn_info_message_distro() {
  #
  # Distro Details
  # =====================================
  # Distro:    Ubuntu 14.04.4 LTS
  # Arch:      x86_64
  # Kernel:    3.13.0-79-generic
  # Hostname:  hostname
  # tmux:      tmux 1.8
  # glibc:     2.19

  echo -e ""
  echo -e "${lightyellow}Distro Details${default}"
  fn_print_dash
  {
    echo -e "${lightblue}Distro:\t${default}${distro_name}"
    echo -e "${lightblue}Arch:\t${default}${arch}"
    echo -e "${lightblue}Kernel:\t${default}${kernel}"
    echo -e "${lightblue}Hostname:\t${default}${HOSTNAME}"
    echo -e "${lightblue}Uptime:\t${default}${days}d, ${hours}h, ${minutes}m"
    echo -e "${lightblue}tmux:\t${default}${tmux_version}"
  } | column -s $'\t' -t
}

fn_info_message_server_resource() {
  #
  # Server Resource
  # ==========================================================================================================================================================================================================================================
  # CPU
  # Model:      Intel(R) Xeon(R) CPU E5-2680 v3 @ 2.50GHz
  # Cores:      4
  # Frequency:  2499.994 MHz
  # Avg Load:   0.20, 0.08, 0.01
  #
  # Memory
  # Mem:       total  used   free   cached  available
  # Physical:  7.8GB  598MB  7.0GB  4.0GB   7.0GB
  # Swap:      512MB  0B     512MB
  #
  # Storage
  # Filesystem:	/dev/sda
  # Total:			157G
  # Used:				138G
  # Available:	12G

  echo -e ""
  echo -e "${lightyellow}Server Resource${default}"
  fn_print_dash
  {
    echo -e "${lightyellow}CPU\t${default}"
    echo -e "${lightblue}Model:\t${default}${cpu_model}"
    echo -e "${lightblue}Cores:\t${default}${cpu_cores}"
    echo -e "${lightblue}Frequency:\t${default}${cpu_frequency} MHz"
    echo -e "${lightblue}Avg Load:\t${default}${load}"
  } | column -s $'\t' -t
  echo -e ""
  {
    echo -e "${lightyellow}Memory\t${default}"
    echo -e "${lightblue}Mem:\t${lightblue}total\tused\tfree\tcached\tavailable${default}"
    echo -e "${lightblue}Physical:\t${default}${phys_mem_total}\t${phys_mem_used}\t${phys_mem_free}\t${phys_mem_cached}\t${phys_mem_available}${default}"
    echo -e "${lightblue}Swap:\t${default}${swap_total}\t${swap_used}\t${swap_free}${default}"
  } | column -s $'\t' -t
  echo -e ""
  {
    echo -e "${lightyellow}Storage${default}"
    echo -e "${lightblue}Filesystem:\t${default}${file_system}"
    echo -e "${lightblue}Total:\t\t${default}${total_space}"
    echo -e "${lightblue}Used:\t\t${default}${used_space}"
    echo -e "${lightblue}Available:\t${default}${avail_space}"
  } | column -s $'\t' -t
  echo -e ""
  {
    echo -e "${lightyellow}Network${default}"
    if [ "${net_int}" ]; then
      echo -e "${lightblue}Interface:\t${default}${net_int}"
    fi
    if [ "${net_link}" ]; then
      echo -e "${lightblue}Link Speed:\t${default}${net_link}"
    fi
    echo -e "${lightblue}IP:\t${default}${ip}"
    if [ "${ip}" != "${ext_ip}" ]; then
      echo -e "${lightblue}Internet IP:\t${default}${ext_ip}"
    fi
  } | column -s $'\t' -t
}

fn_info_message_daemon() {
  #
  # Daemon Details
  #==========================================================================================================================================================================================================================================
  # Script name:           bitcoind
  # LinuxGSM version:     v19.1
  # User:                   bitcoind
  # Location:               /home/bitcoind
  # Config file:            /home/bitcoind/BTC/conf/coin.conf

  echo -e ""
  echo -e "${lightgreen}${selfname}Daemon Details${default}"
  fn_print_dash
  {
    # Daemon name
    echo -e "${lightblue}Daemon name:\t${default}${self_name}"

    # Version
    if [ -n "${version}" ]; then
      echo -e "${lightblue}Version:\t${default}${version}"
    fi

    # Daemon Version
    if [ -n "${daemon_version}" ]; then
      echo -e "${lightblue}Daemon Version:\t${default}${daemon_version}"
    fi

    # User
    echo -e "${lightblue}User:\t${default}$(whoami)"

    # Script location
    echo -e "${lightblue}Location:\t${default}${root_dir}"

    # Config file location
    if [ -n "${daemon_config_file}" ]; then
      if [ -f "${daemon_config_file}" ]; then
        echo -e "${lightblue}Config file:\t${default}${daemon_config_file}"
      elif [ -d "${daemon_cfg_dir}" ]; then
        echo -e "${lightblue}Config dir:\t${default}${daemon_cfg_dir}"
      else
        echo -e "${lightblue}Config file:\t${default}${red}${daemon_config_file}${default} (${red}FILE MISSING${default})"
      fi
    fi
  } | column -s $'\t' -t
}

fn_info_message_statusbottom(){
	echo -e ""
	if [ "${status}" == "0" ]; then
		echo -e "${lightblue}Status:\t${red}OFFLINE${default}"
	else
		echo -e "${lightblue}Status:\t${green}ONLINE${default}"
	fi
	echo -e ""
}

fn_info_logs(){
	echo -e ""
	echo -e "${self_name} Logs"
	fn_print_dash

	if [ -n "${log_dir}" ]; then
		if [ ! "$(ls -A "${log_dir}")" ]; then
			echo -e "${log_dir} (NO LOG FILES)"
		elif [ ! -s "${daemon_logs}" ]; then
			echo -e "${daemon_logs} (LOG FILE IS EMPTY)"
		else
			echo -e "${daemon_logs}"
			tail -25 "${daemon_logs}"
		fi
		echo -e ""
	fi

	if [ -n "${console_log}" ]; then
		echo -e "\nConsole log\n===================="
		if [ ! "$(ls -A "${log_dir}")" ]; then
			echo -e "${log_dir} (NO LOG FILES)"
		elif [ ! -s "${console_log}" ]; then
			echo -e "${console_log} (LOG FILE IS EMPTY)"
		else
			echo -e "${console_log}"
			tail -25 "${console_log}" | awk '{ sub("\r$", ""); print }'
		fi
		echo -e ""
	fi
}
#!/usr/bin/env bash

local command_name="CHECK"

fn_install_berkeley_db() {
  if [ "${berkeley_status}" != "0" ]; then
    fn_print_dots_nl "Adding Berkeley DB repository"
    if [ "${auto_install}" == "1" ]; then
      sudo -n true >/dev/null 2>&1
    else
      sudo -v >/dev/null 2>&1
    fi
    if [ $? -eq 0 ]; then
      fn_print_info_nl "Automatically adding Berkeley DB repository"
      fn_script_log_info "Automatically adding Berkeley DB repository"
      echo -en ".\r"
      sleep 1
      echo -en "..\r"
      sleep 1
      echo -en "...\r"
      sleep 1
      echo -en "   \r"
      if [ "${distro_id}" == "ubuntu" ] || [ "${distro_id}" == "Ubuntu" ]; then
        if [ "${distro_version}" == "20.04" ]; then
          cmd="sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C70EF1F0305A1ADB9986DBD8D46F45428842CE5E;echo 'deb http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu bionic main' | sudo tee /etc/apt/sources.list.d/berkeley-db.list;sudo apt update;sudo apt install -y libdb4.8-dev libdb4.8++-dev"
          eval "${cmd}"
        elif [ "${distro_version}" == "18.04" ]; then
          cmd="sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C70EF1F0305A1ADB9986DBD8D46F45428842CE5E;echo 'deb http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu bionic main' | sudo tee /etc/apt/sources.list.d/berkeley-db.list;sudo apt update;sudo apt install -y libdb4.8-dev libdb4.8++-dev"
          eval "${cmd}"
        elif [ "${distro_version}" == "16.04" ]; then
          cmd="sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C70EF1F0305A1ADB9986DBD8D46F45428842CE5E;echo 'deb http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu xenial main' | sudo tee /etc/apt/sources.list.d/berkeley-db.list;sudo apt update;sudo apt install -y libdb4.8-dev libdb4.8++-dev"
          eval "${cmd}"
        elif [ "${distro_version}" == "14.04" ]; then
          cmd="sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C70EF1F0305A1ADB9986DBD8D46F45428842CE5E;echo 'deb http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu trusty main' | sudo tee /etc/apt/sources.list.d/berkeley-db.list;sudo apt update;sudo apt install -y libdb4.8-dev libdb4.8++-dev"
          eval "${cmd}"
        else
          fn_print_warn_nl "Installing Berkeley DB"
          echo -e "Berkeley DB install not available for ${distro_name}"
          berkeley_auto_install="1"
        fi
      elif [ "${distro_id}" == "debian" ] || "${distro_id}" == "Debian"; then
        if [ "${distro_version}" == "10" ]; then
          cmd="sudo apt install apt-transport-https dirmngr;sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C70EF1F0305A1ADB9986DBD8D46F45428842CE5E;echo 'deb http://ftp.de.debian.org/debian buster main' | sudo tee /etc/apt/sources.list.d/berkeley-db.list;sudo apt update;sudo apt install -y libdb4.8-dev libdb4.8++-dev"
          eval "${cmd}"
        elif [ "${distro_version}" == "9" ]; then
          cmd="sudo apt install apt-transport-https dirmngr;sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C70EF1F0305A1ADB9986DBD8D46F45428842CE5E;echo 'deb http://ftp.de.debian.org/debian stretch main' | sudo tee /etc/apt/sources.list.d/berkeley-db.list;sudo apt update;sudo apt install -y libdb4.8-dev libdb4.8++-dev"
          eval "${cmd}"
        elif [ "${distro_version}" == "8" ]; then
          cmd="sudo apt install apt-transport-https dirmngr;sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C70EF1F0305A1ADB9986DBD8D46F45428842CE5E;echo 'deb http://ftp.de.debian.org/debian jessie main' | sudo tee /etc/apt/sources.list.d/berkeley-db.list;sudo apt update;sudo apt install -y libdb4.8-dev libdb4.8++-dev"
          eval "${cmd}"
        else
          echo -e "Berkeley DB install not available for ${distro_name}"
          berkeley_auto_install="1"
        fi
      elif [ "${distro_id}" == "centos" ]; then
        if [ "${distro_version}" == "8" ]; then
          cmd="rpm --import 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC70EF1F0305A1ADB9986DBD8D46F45428842CE5E';echo 'https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/perl-BerkeleyDB-0.51-4.el7.x86_64.rpm' | sudo tee /etc/yum.repos.d/berkeley-db.repo;sudo yum install -y perl-BerkeleyDB"
          eval "${cmd}"
        elif [ "${distro_version}" == "7" ]; then
          cmd="rpm --import 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC70EF1F0305A1ADB9986DBD8D46F45428842CE5E';echo 'https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/perl-BerkeleyDB-0.51-4.el7.x86_64.rpm' | sudo tee /etc/yum.repos.d/berkeley-db.repo;sudo yum install -y perl-BerkeleyDB"
          eval "${cmd}"
        elif [ "${distro_version}" == "6" ]; then
          cmd="rpm --import 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC70EF1F0305A1ADB9986DBD8D46F45428842CE5E';echo 'https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/perl-BerkeleyDB-0.51-4.el7.x86_64.rpm' | sudo tee /etc/yum.repos.d/berkeley-db.repo;sudo yum install -y perl-BerkeleyDB"
          eval "${cmd}"
        else
          echo -e "Berkeley DB install not available for ${distro_name}"
          berkeley_auto_install="1"
        fi
      elif [ "${distro__id}" == "fedora" ]; then
        cmd="rpm --import 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC70EF1F0305A1ADB9986DBD8D46F45428842CE5E';echo 'https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/perl-BerkeleyDB-0.51-4.el7.x86_64.rpm' | sudo tee /etc/yum.repos.d/berkeley-db.repo;sudo yum install -y perl-BerkeleyDB"
        eval "${cmd}"
      else
        echo -e "Berkeley DB install not available for ${distro_name}"
        berkeley_auto_install="1"
      fi
      if [ "${berkeley_auto_install}" == "1" ]; then
        fn_print_failure_nl "Unable to install Berkeley DB"
        fn_script_log_fatal "Unable to install Berkeley DB"
        berkeley_auto_install="1"
      else
        fn_print_complete_nl "Installing Berkeley DB completed"
        fn_script_log_pass "Installing Berkeley DB completed"
        berkeley_auto_install="0"
      fi
    else
      fn_print_information_nl "Installing Berkeley DB"
      echo -e ""
      fn_print_warning_nl "$(whoami) does not have sudo access. Manually install Berkeley DB repository"
      fn_script_log_warn "$(whoami) does not have sudo access. Manually install Berkeley DB repository"
    fi
  fi
}

fn_found_missing_deps() {
  if [ "${#array_deps_missing[@]}" != "0" ]; then
    fn_print_warning_nl "Missing dependicies: ${red}${array_deps_missing[@]}${default}"
    fn_script_log_warn "Missing dependicies: ${array_deps_missing[@]}"
    fn_sleep_time

    if [ -n "${berkeley_status}" ]; then
      fn_install_berkeley_db
    fi
    if [ "${auto_install}" == "1" ]; then
      sudo -n true >/dev/null 2>&1
    else
      sudo -v >/dev/null 2>&1
    fi
    if [ $? -eq 0 ]; then
      fn_print_info_nl "Automatically adding Berkeley DB repository"
      fn_script_log_info "Automatically adding Berkeley DB repository"
      echo -en ".\r"
      sleep 1
      echo -en "..\r"
      sleep 1
      echo -en "...\r"
      sleep 1
      echo -en "   \r"
      if [ -n "$(command -v dpkg-query 2>/dev/null)" ]; then
        cmd="sudo apt update; sudo apt install -y ${array_deps_missing[@]}"
        eval "${cmd}"
      elif [ -n "$(command -v dnf 2>/dev/null)" ]; then
        cmd="sudo dnf -y install ${array_deps_missing[@]}"
        eval "${cmd}"
      elif [ -n "$(command -v yum 2>/dev/null)" ]; then
        cmd="sudo yum -y install ${array_deps_missing[@]}"
        eval "${cmd}"
      fi
      if [ $? != "0" ]; then
        fn_print_failure_nl "Unable to install dependicies"
        fn_script_log_fatal "Unable to install dependicies"
        echo -e ""
        fn_print_warning_nl "Manually install dependicies"
        fn_script_log_warn "Manually install dependicies"
        if [ -n "$(command -v dpkg-query 2>/dev/null)" ]; then
          echo -e "    sudo apt update; sudo apt install -y ${array_deps_missing[@]}"
        elif [ -n "$(command -v dnf 2>/dev/null)" ]; then
          echo -e"     sudo dnf -y install ${array_deps_missing[@]}"
        elif [ -n "$(command -v yum 2>/dev/null)" ]; then
          echo -e "    sudo yum -y install ${array_deps_missing[@]}"
        fi
      else
        fn_print_complete_nl "Install dependicies completed"
        fn_script_log_pass "Install dependicies completed"
      fi
    else
      echo -e ""
      fn_print_warning_nl "$(whoami) does not have sudo access. Manually install dependicies"
      fn_script_log_warn "$(whoami) does not have sudo access. Manually install dependicies"
      if [ -n "$(command -v dpkg-query 2>/dev/null)" ]; then
        echo -e "    sudo apt update; sudo apt install -y ${array_deps_missing[@]}"
      elif [ -n "$(command -v dnf 2>/dev/null)" ]; then
        echo -e"     sudo dnf -y install ${array_deps_missing[@]}"
      elif [ -n "$(command -v yum 2>/dev/null)" ]; then
        echo -e "    sudo yum -y install ${array_deps_missing[@]}"
      fi
      echo -e ""
    fi
    if [ "${function_self_name}" == "command_install.sh" ]; then
      sleep 5
    fi
  else
    if [ "${function_self_name}" == "command_install.sh" ]; then
      fn_print_information_nl "Required dependicies already installed"
      fn_script_log_info "Required dependicies already installed"
    fi
  fi
}

fn_deps_detector() {
  # Checks if dependency is missing
  if [ "${tmux_check}" == "1" ]; then
    # Added for users compiling tmux from source to bypass check
    dep_status=0
    dep_to_check="tmux"
    unset tmux_check
  elif [ "${dep_to_check}" == "berkeley-complete" ]; then
    if [ -n "$(ls /usr/lib/libdb-4.8.so 2>/dev/null)" ]; then
      dep_status=0
      berkeley_status=0
      unset array_deps_required[0]
    else
      dep_status=1
      berkeley_status=1
    fi
  elif [ -n "$(command -v dpkg-query 2>/dev/null)" ]; then
    dpkg-query -W -f='${Status}' "${dep_to_check}" 2>/dev/null | grep -q -P '^install ok installed'
    dep_status=$?
  elif [ -n "$(command -v rpm 2>/dev/null)" ]; then
    rpm -q "${dep_to_check}" >/dev/null 2>&1
    dep_status=$?
  fi

  if [ "${dep_status}" == "0" ]; then
    # If dependency is found
    missing_dep=0
    if [ "${function_self_name})" == "command_install.sh" ]; then
      echo -e "${green}${dep_to_check}${default}"
      fn_sleep_time
    fi
  else
    # If dependency is not found
    missing_dep=1
    if [ "${function_self_name}" == "command_install.sh" ]; then
      echo -e "${red}${dep_to_check}${default}"
      fn_sleep_time
    fi
  fi

  # Missing dependencies are added to array_deps_missing
  if [ "${missing_dep}" == "1" ]; then
    array_deps_missing+=("${dep_to_check}")
  fi
}

fn_check_loop() {
  for dep_to_check in "${array_deps_required[@]}"; do
    fn_deps_detector
  done

  fn_found_missing_deps
}

# Generate required dependicies
fn_deps_build_debain() {
  array_deps_missing=()
  array_deps_required=(curl wget gzip bzip2 bc jq sysvbanner unzip)

  if [ -n "$(command -v tmux 2>/dev/null)" ]; then
    tmux_check=1
  else
    array_deps_required+=(tmux)
  fi

  # Daemon specific requirements
  if [ "${short_name}" == "BTC" ]; then
    array_deps_required+=(berkeley-complete build-essential)
  elif [ "${short_name}" == "DOGE" ]; then
    array_deps_required+=(berkeley-complete build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev)
  elif [ "${short_name}" == "LTC" ]; then
    array_deps_required+=(berkeley-complete build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev)
  elif [ "${short_name}" == "NMC" ]; then
    array_deps_required+=(berkeley-complete build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev)
  elif [ "${short_name}" == "PPC" ]; then
    array_deps_required+=(berkeley-complete build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev)
  elif [ "${short_name}" == "XPM" ]; then
    array_deps_required+=(berkeley-complete build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev)
  fi

  fn_check_loop
}

fn_deps_build_redhat() {
  array_deps_missing=()
  array_deps_required=(epel-release curl wget gzip bzip2 bc jq sysvbanner unzip)

  if [ -n "$(command -v tmux 2>/dev/null)" ]; then
    tmux_check=1
  else
    array_deps_required+=(tmux)
  fi

  # Daemon specific requirements
  if [ "${short_name}" == "BTC" ]; then
    array_deps_required+=(build-essential)
  elif [ "${short_name}" == "DOGE" ]; then
    array_deps_required+=(berkeley-complete build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev)
  elif [ "${short_name}" == "LTC" ]; then
    array_deps_required+=(gcc-c++ libtool make autoconf automake openssl-devel libevent-devel boost-devel libdb4-devel libdb4-cxx-devel python3)
  elif [ "${short_name}" == "NMC" ]; then
    array_deps_required+=(gcc-c++ libtool make autoconf automake openssl-devel libevent-devel boost-devel libdb4-devel libdb4-cxx-devel python3)
  elif [ "${short_name}" == "PPC" ]; then
    array_deps_required+=(gcc-c++ libtool make autoconf automake openssl-devel libevent-devel boost-devel libdb4-devel libdb4-cxx-devel python3)
  elif [ "${short_name}" == "XPM" ]; then
    array_deps_required+=(gcc-c++ libtool make autoconf automake openssl-devel libevent-devel boost-devel libdb4-devel libdb4-cxx-devel python3)
  fi

  fn_check_loop
}

if [ "$(whoami)" == "root" ]; then
  echo -e ""
  echo -e "${lightyellow}Checking dependicies as root${default}"
  fn_print_dash
  fn_print_information_nl "Checking any missing dependicies for ${daemon_name}"
  fn_print_information_nl "This will NOT install ${daemon_name} daemon"
  fn_sleep_time
else
  echo -e ""
  echo -e "${lightyellow}Checking dependicies${default}"
  fn_print_dash
fi

# Filter checking in to Debian or Redhat
info_distro.sh
if [ -f "/etc/debian_version" ]; then
  fn_deps_build_debain
elif [ -f "/etc/redhat-release" ]; then
  fn_deps_build_redhat
else
  fn_print_warning_nl "${distro_name} dependency checking unavailable"
fi

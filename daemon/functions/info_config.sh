#!/usr/bin/env bash

local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

fn_info_config_bitcoind() {
  if [ ! -f "${daemon_config_file}" ]; then
    rpcuser="${unavailable}"
    rpcpassword="${unavailable}"
    rpcport="${zero}"
    testnet="${zero}"
    maxconnections="${zero}"
    server="${zero}"
    rpctimeout="${zero}"
  else
    rpcuser="$(grep 'rpcuser' ${daemon_config_file} | sed -e 's/rpcuser//g' | tr -d '=' | grep -v -e '#')"
    rpcpassword="$(grep 'rpcpassword' ${daemon_config_file} | sed -e 's/rpcpassword//g' | tr -d '=' | grep -v -e '#')"
    rpcport="$(grep 'rpcport' ${daemon_config_file} | sed -e 's/rpcport//g' | tr -d '=' | grep -v -e '#')"
    rpctimeout="$(grep 'rpcclienttimeout' ${daemon_config_file} | sed -e 's/rpcclienttimeout//g' | tr -d '=' | grep -v -e '#')"
    testnet="$(grep 'testnet' ${daemon_config_file} | sed -e 's/testnet//g' | tr -d '=' | grep -v -e '#')"
    maxconnections="$(grep 'maxconnections' ${daemon_config_file} | sed -e 's/maxconnections//g' | tr -d '=' | grep -v -e '#')"
    server="$(grep 'server' ${daemon_config_file} | sed -e 's/server//g' | tr -d '=' | grep -v -e '#')"

    # Not set
    rpcuser=${rpcuser:-"NOT SET"}
    rpcpassword=${rpcpassword:-"NOT SET"}
    rpcport=${rpcport:-"0"}
    rpctimeout=${rpctimeout:-"0"}
    testnet=${testnet:-"0"}
    maxconnections=${maxconnections:-"0"}
    server=${server:-"0"}
  fi
}

if [ "${short_name}" == "BTC" ]; then
  fn_info_config_bitcoind
  daemon_bin_dir="${daemon_files}/bitcoin-0.19.0.1/bin"
elif [ "${short_name}" == "DOGE" ]; then
  fn_info_config_bitcoind
  daemon_bin_dir="${daemon_files}/dogecoin-1.14.2/bin"
elif [ "${short_name}" == "LTC" ]; then
  fn_info_config_bitcoind
  daemon_bin_dir="${daemon_files}/litecoin-0.17.1/bin"
fi

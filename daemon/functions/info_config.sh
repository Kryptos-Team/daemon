#!/usr/bin/env bash

local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

fn_info_config_litecoind() {
  if [ ! -f "${daemon_cfg_dir}/litecoin.conf" ]; then
    rpcuser="${unavailable}"
    rpcpassword="${unavailable}"
    rpcport="${zero}"
    testnet="${zero}"
    maxconnections="${zero}"
    server="${zero}"
    rpctimeout="${zero}"
  else
    rpcuser="$(grep 'rpcuser' ${daemon_cfg_dir}/litecoin.conf | sed -e 's/rpcuser//g' | tr -d '=' | grep -v -e '#')"
    rpcpassword="$(grep 'rpcpassword' ${daemon_cfg_dir}/litecoin.conf | sed -e 's/rpcpassword//g' | tr -d '=' | grep -v -e '#')"
    rpcport="$(grep 'rpcport' ${daemon_cfg_dir}/litecoin.conf | sed -e 's/rpcport//g' | tr -d '=' | grep -v -e '#')"
    rpctimeout="$(grep 'rpctimeout' ${daemon_cfg_dir}/litecoin.conf | sed -e 's/rpctimeout//g' | tr -d '=' | grep -v -e '#')"
    testnet="$(grep 'testnet' ${daemon_cfg_dir}/litecoin.conf | sed -e 's/testnet//g' | tr -d '=' | grep -v -e '#')"
    maxconnections="$(grep 'maxconnections' ${daemon_cfg_dir}/litecoin.conf | sed -e 's/maxconnections//g' | tr -d '=' | grep -v -e '#')"
    server="$(grep 'server' ${daemon_cfg_dir}/litecoin.conf | sed -e 's/server//g' | tr -d '=' | grep -v -e '#')"

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

if [ "${short_name}" == "LTC" ]; then
  fn_info_config_litecoind
fi

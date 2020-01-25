#!/usr/bin/env bash

fn_exit_trap() {
  echo -e ""
  core_exit.sh
}

# trap to give an exit code
trap fn_exit_trap INT

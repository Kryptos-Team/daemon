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
  creeol="\r033[K"
}

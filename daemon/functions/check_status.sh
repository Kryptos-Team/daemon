#!/usr/bin/env bash

local command_name="CHECK"
local function_self_name=$(basename "$(readlink -f "${BASH_SOURCE[0]}")")

status=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | grep -Ecx "^${self_name}")

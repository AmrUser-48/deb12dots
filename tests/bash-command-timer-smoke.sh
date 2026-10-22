#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
BCT_TIME_FORMAT=''
BCT_COLOR_OUTPUT=0
BCT_MILLIS=1
PS1='test> '
PROMPT_COMMAND='printf preserved'
source "$ROOT/bash-command-timer/bash_command_timer.sh"

_bct_format_duration 1234567890
[[ $BCT_FORMATTED_DURATION == '1s234' ]]
_bct_format_duration 0
[[ $BCT_FORMATTED_DURATION == '0s000' ]]
_bct_format_duration 86400000000000
[[ $BCT_FORMATTED_DURATION == '1d 0s000' ]]
_bct_format_duration invalid
[[ $BCT_FORMATTED_DURATION == '0s000' ]]
COLUMNS=40
_bct_make_prompt_prefix 1234567890 0
[[ $BCT_TIMER_PROMPT_PREFIX == *'[ 1s234 ]'*'\n' ]]
[[ ${#BCT_TIMER_PROMPT_PREFIX} -gt 10 ]]
[[ $PS1 == 'test> ' ]]
[[ $PROMPT_COMMAND == 'printf preserved' ]]

# Exercise the real timestamp path and prompt assembly.
BCT_FIRST_PROMPT=0
BCT_AT_PROMPT=1
_bct_preexec
[[ $BCT_AT_PROMPT == 0 && $BCT_COMMAND_START_NS =~ ^[0-9]+$ ]]
BCT_LAST_STATUS=0
PS1='test> '
_bct_postcmd
[[ $BCT_AT_PROMPT == 1 && $PS1 == *'[ '* ]]

# The fallback DEBUG trap checks the prompt state before dispatching the function.
grep -Fq '[[ ${BCT_AT_PROMPT:-0} != 1 ]] || _bct_preexec' "$ROOT/bash-command-timer/bash_command_timer.sh"

printf '%s\n' 'bash-command-timer smoke tests: PASS'


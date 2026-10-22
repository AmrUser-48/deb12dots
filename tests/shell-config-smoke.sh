#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
bash -n "$repo_root/.aaliases" "$repo_root/.bashrc" "$repo_root/etc/profile.d/40-user.sh"

# Source the shared aliases in a clean Bash without loading the user's dotfiles.
ALIASES_FILE="$repo_root/.aaliases" bash --noprofile --norc -c '
    source "$ALIASES_FILE"
    [[ $(alias src) == *"source ~/.bashrc"* ]]
    [[ $(alias ashow) == *"less ~/.aaliases"* ]]
    [[ $(alias s) == *"ss -tpn"* ]]
    declare -F greg >/dev/null
'

# Check shell-specific selection when Zsh is available on the runner.
if command -v zsh >/dev/null 2>&1; then
    ALIASES_FILE="$repo_root/.aaliases" zsh -f -c '
        source "$ALIASES_FILE"
        [[ $(alias src) == *"source ~/.zshrc"* ]]
        [[ $(alias ashow) == *"less ~/.aaliases"* ]]
    '
fi

# Prompt markers use case matching on each tool's environment variable.
grep -Fq 'case ${LF_LEVEL-} in' "$repo_root/.bashrc"
grep -Fq 'case ${RANGER_LEVEL-} in' "$repo_root/.bashrc"
grep -Fq 'case ${MC_SID-} in' "$repo_root/.bashrc"
grep -Fq ']lf' "$repo_root/.bashrc"
grep -Fq ']ranger' "$repo_root/.bashrc"
grep -Fq ']mc' "$repo_root/.bashrc"
grep -Fq '\[\e[01;34m\][ ' "$repo_root/.bashrc"
grep -Fq 'printf' "$repo_root/.bashrc"
grep -Fq '.bashrc' "$repo_root/.bashrc"
# The profile script prints one debug marker at the end, not a fake service status.
grep -Fq 'Simple startup debug marker' "$repo_root/etc/profile.d/40-user.sh"
grep -Fq 'printf '\''\\033[1;32m * \\033[1;34m[\\033[0m %s \\033[1;34m]\\033[0m\\n'\'' "/etc/profile.d/40-user.sh"' "$repo_root/etc/profile.d/40-user.sh"
! grep -Fq 'Loading /etc/profile.d/40-user.sh ...' "$repo_root/etc/profile.d/40-user.sh"
! grep -Fq '[ ok ]' "$repo_root/etc/profile.d/40-user.sh"
[[ $(tail -n 1 "$repo_root/etc/profile.d/40-user.sh") == *'/etc/profile.d/40-user.sh'* ]]
echo "Shell configuration smoke tests passed."

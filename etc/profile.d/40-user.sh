# OpenRC-style shell-startup status line.
printf '\033[1;32m * \033[0mLoading /etc/profile.d/40-user.sh ...'

shopt -s histappend

# no lesspipe, fast
export LESSOPEN=""
export SFK_COLORS=b

alias acfg="${EDITOR} $HOME/.bashrc"
alias bcfg="${EDITOR} $HOME/.bashrc"

## aliases
alias md="mkdir -pv"
alias m="less -RI"
alias g="grep -i"
alias df="df -h"
alias rm="rm -v"
alias l="ls -Ashp --group-directories-first"
alias ll="ls -lAsh --group-directories-first"
alias mv="mv -v"
alias cp="cp -v"
alias hop="htop -u $USER"
alias df="df -h"
alias dy="du -h"
alias dy="du -h"
alias fd="fdfind"

mkcd() {
mkdir -pv "$1" && cd "$1"
pwd
}


ftext() {
   grep -ri "$@" | less -RSI
 }

mkbk() {
    cp "$1" "$(date "+%Y_%m_%d-%H-%M-%S")_$1"
}

gootr() {
trans :uk -b "$@"
}


# OpenRC's eend success status, printed after the profile setup.
printf ' \033[1;32m[ ok ]\033[0m\n'

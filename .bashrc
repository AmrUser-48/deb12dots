# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# OpenRC-style marker: this file only reaches here for interactive Bash shells.
printf '\033[1;32m * \033[1;34m[\033[0m %s \033[1;34m]\033[0m\n' "$HOME/.bashrc"

export EDITOR=nvim
export PAGER=less

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend cmdhist

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# Enable bracketed paste so pasted long commands are handled as one Readline edit.
bind 'set enable-bracketed-paste on'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Keep nonprinting terminal sequences in PS1 inside \\[...\\]; Readline uses this for long-line cursor tracking.
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# lf exports LF_LEVEL to shells it starts (for example, with its default w binding).
# Match the variable directly; do not scan the process tree.
case ${LF_LEVEL-} in
    ('') ;;
    (*)
        PS1='\[\e[01;34m\][ \[\e[01;32m\]lf\[\e[01;34m\] ]\[\e[00m\] '"$PS1"
        ;;
esac

# Ranger sets or increments RANGER_LEVEL for processes it launches.
case ${RANGER_LEVEL-} in
    ('') ;;
    (*)
        PS1='\[\e[01;34m\][ \[\e[01;32m\]ranger\[\e[01;34m\] ]\[\e[00m\] '"$PS1"
        ;;
esac

# Midnight Commander sets MC_SID for its subshell; child shells inherit it.
case ${MC_SID-} in
    ('') ;;
    (*)
        PS1='\[\e[01;34m\][ \[\e[01;32m\]mc\[\e[01;34m\] ]\[\e[00m\] '"$PS1"
        ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'
alias fd='fdfind'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.aaliases ]; then
    . ~/.aaliases
fi


     bind '"\C-o":"\C-u lfcd\C-m"'  # bash
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}


# More binds

     bind '"\eq":"\C-a tldr \C-m"'
     bind '"\es":"\C-a echo '\''\C-e'\'' >> ~/notes \C-m"'
     bind '"\el":"\C-u l \C-m"'
     bind '"\e\\":" \| "'
     bind '"\eg":" \| grep -i "'


# - to _ 
# this is replacing all - to _ 
#     function cd() {
#  builtin cd "${@//-/_}"
#}

cd() {
  local target="${1//-/_}"
  if [[ -z "$1" ]]; then
    builtin cd
  elif [[ "$1" == "-" ]]; then
    builtin cd "$1"
  elif [[ -d "$target" ]]; then
    builtin cd "$target"
  else
    builtin cd "$1"
  fi
}

     [ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash
[ -f /usr/share/bash-completion/completions/fzf ] && source /usr/share/bash-completion/completions/fzf

# Command timer: maintained, Readline-aware implementation.
_bct_script="${BASH_COMMAND_TIMER_PATH:-$HOME/.local/lib/bash-command-timer/bash_command_timer.sh}"
if [[ -r "$_bct_script" ]]; then
    source "$_bct_script"
fi
unset _bct_script


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# run help
run-help() {
    local cmd="${READLINE_LINE%% *}"
    if [[ -z "$cmd" ]]; then
        echo "No command on line." >&2
        return 1
    fi

    # Try --help, man, tldr (if installed), fallback to help -m
    if "$cmd" --help 2>&1 | less; then
        return 0
    elif man "$cmd" 2>/dev/null; then
        return 0
    elif command -v tldr &>/dev/null && tldr "$cmd"; then
        return 0
    elif help "$cmd" 2>/dev/null | less; then
        return 0
    else
        echo "No help available for '$cmd'." >&2
        return 1
    fi
}

# Bind Alt+h to run-help
bind -x '"\eh": run-help'
########################

_aichat_completion() {
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    local options="
        --help
        --version
        --role
        -r
        --session
        -s
        --list-roles
        --list-models
        --config-dir
        --no-stream
        --prompt
    "

    case "$prev" in
        --role|-r)
            COMPREPLY=( $(compgen -W "$(aichat --list-roles 2>/dev/null)" -- "$cur") )
            ;;
        --session|-s)
            COMPREPLY=( $(compgen -W "$(aichat --list-sessions 2>/dev/null)" -- "$cur") )
            ;;
        *)
            COMPREPLY=( $(compgen -W "$options" -- "$cur") )
            ;;
    esac
}

complete -F _aichat_completion aichat

#PROMPT_COMMAND='printf "\e[90m"; printf "─%.0s" $(seq 1 $COLUMNS); printf "\e[0m\n"'

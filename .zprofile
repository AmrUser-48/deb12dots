# vi: ft=zsh
echo zprofile 
PATH="$HOME/.local/bin:$PATH"

# XDG manual insteed (elogind | pam-rundir | mkrundir)
#if [ -z "$XDG_RUNTIME_DIR" ]; then
#        XDG_RUNTIME_DIR="/tmp/$(id -u)-runtime-dir"
#
#        mkdir -pm 0700 "$XDG_RUNTIME_DIR"
#        export XDG_RUNTIME_DIR
#fi

# Autostart X an login
#if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
#	exec startx
#fi


##   Settings
#RANGER_LOAD_DEFAULT_RC=FALSE

#export EDITOR=nvim

## PAGER
#export PAGER=""
#export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh  %s" # Syn hilite in pager
#
#export LESSOPEN=" | $HOME/bin/lesspipe.sh %s"

export LESS='--mouse --wheel-lines=3 -Ri'   # mouse support

#kbdrate -r 22 -d 200 > /dev/null

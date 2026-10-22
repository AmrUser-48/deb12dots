  autoload -Uz promptinit
  promptinit
  prompt adam2

echo zshrc

## Copy from git:
## More suitable for .zshenv
#EDITOR=nvim

#PROMPT='λ %3~%(!.#.$)%(?.. [%?]) '
## fast n clean: no fucking stupid colors and other shit rah!
PROMPT='%2~ %Bλ%b '

## History settings: {{{
HISTFILE=~/.history-zsh
HISTSIZE=20000
SAVEHIST=20000
setopt append_history           # allow multiple sessions to append to one history
setopt bang_hist                # treat ! special during command expansion
setopt extended_history         # Write history in :start:elasped;command format
setopt hist_expire_dups_first   # expire duplicates first when trimming history
setopt hist_find_no_dups        # When searching history, don't repeat
setopt hist_ignore_dups         # ignore duplicate entries of previous events
setopt hist_ignore_space        # prefix command with a space to skip it's recording
setopt hist_reduce_blanks       # Remove extra blanks from each command added to history
setopt hist_verify              # Don't execute immediately upon history expansion
setopt inc_append_history       # Write to history file immediately, not when shell quits
setopt share_history            # Share history among all sessions
setopt histignorespace
##}}}

## Tab completion:  {{{
## why not work  :TODO do copy from robbyrussel #fpath=(~/.config/zsh/compl $fpath)

## The following lines were added by compinstall {{{

zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' list-prompt #%SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
#zstyle ':completion:*' matcher-list '' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=long-list select=0
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/mint/.zshrc'

autoload -Uz compinit
compinit
## End of lines added by compinstall }}}

#autoload -Uz compinit && compinit
##   Completions, case insensetive
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#setopt complete_in_word         # cd /ho/sco/tm<TAB> expands to /home/scott/tmp
setopt completeinword
#setopt auto_menu                # show completion menu on succesive tab presses
#setopt autocd                   # cd to a folder just by typing it's name
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&' # These "eat" the auto prior space after a tab complete
## }}}

## MISC
setopt interactive_comments     # allow # comments in shell; good for copy/paste
unsetopt correct_all            # I don't care for 'suggestions' from ZSH
export BLOCK_SIZE="'1"          # Add commas to file sizes

export PROMPT_EOL_MARK=''
export PATH=$PATH:$HOME/bin:$HOME/.local/bin
source ~/.aaliases

## PATH
# typeset -U path                 # keep duplicates out of the path
# path+=(.)                       # append current directory to path (controversial)

## BINDS {{{
#
bindkey -e
zmodload -i zsh/complist
bindkey '\e[3~' delete-char
#bindkey '^p' history-search-backward
#bindkey '^n' history-search-forward

bindkey '\e[5~' backward-word
bindkey '\e[6~' forward-word


bindkey ' '  magic-space

## hardened xterm) {{{
 bindkey -s "^[\\" " | "        # insert spaces around container
 bindkey -s "^[o" "^U lf^M"       # lf file man
# bindkey -s "^[h" "^U cd ..^M"    # Move UP dir
 bindkey -s "^[f" "^U fg\n"     # foreground

bindkey "\e[H" beginning-of-line    # home key, OH or H wth..
bindkey "\e[F" end-of-line          # end key, OF
bindkey "\e[1~" beginning-of-line    # home key, OH or H wth..
bindkey "\e[4~" end-of-line          # end key, OF

bindkey -s "^[q" "\e[H tldr \n"     # tl:dr shortcut

bindkey -s "^[a" "\e[H  a \n"

 #bindkey '\e[A' history-beginning-search-backward # zle widget for whole line search
 #bindkey '\e[B' history-beginning-search-forward

# Tab completion
bindkey '\CI' expand-or-complete-prefix
# Use vim keys in tab complete menu:

 bindkey -M menuselect 'h' vi-backward-char

 bindkey -M menuselect 'k' vi-up-line-or-history

 bindkey -M menuselect 'l' vi-forward-char

 bindkey -M menuselect 'j' vi-down-line-or-history

# bindkey -v '^?' backward-delete-char


autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '\e[A' up-line-or-beginning-search # omg again correct hist-srch behaviour
bindkey '\e[B' down-line-or-beginning-search
  #3-rd
  #autoload -Uz history-search-end 
  #zle -N history-beginning-search-backward-end history-search-end 
  #zle -N history-beginning-search-forward-end history-search-end 
    ##Then using your preferred keys of ^P and ^N: 
  #bindkey -M vicmd "^P" history-beginning-search-backward-end 
  #bindkey -M viins "^P" history-beginning-search-backward-end 
  #
  #bindkey -M vicmd "^N" history-beginning-search-forward-end 
  #bindkey -M viins "^N" history-beginning-search-forward-end
  ##

 # transLATOR shortcut
 ztranslate () {echo ${GREEN}; trans :uk -b "$(xsel -o)" ${NC} ; zle redisplay }
 zle -N ztranslate
 bindkey "^g" ztranslate
##}}}
##}}}

#{{{ LFCD
     bindkey -s '^o' ' lfcd\n'  # zsh
#
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
#}}}

## KEYBINDS {{{
# kill word forward
bindkey '^[[3;3~' kill-word
bindkey -s '^[[29~' ' --help | less \n'
bindkey -s '^[l' '^U l\n' # list files Alt L
bindkey -s '^[c' '^U reset\n'
bindkey -s '^[g' " | grep -i ''\Cb"
#bindkey "^[/" "which-command"
bindkey "^Xv" "quoted-insert"

#}}}
export WORDCHARS='${WORDCHARS}'

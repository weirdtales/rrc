# rrc-zshrc-001

# vars
browser="/usr/bin/lynx"
editor="nvim"
restricted_editor="nvim -Z"
timezone="Australia/Melbourne"
pager="most"


# init
TMP=$HOME/tmp
hostname=`hostname`
cachedir=~/.cache/zsh
mkdir -p $cachedir $TMP

bindkey -e  # e=emacs,v=vi
umask 002

stty -ixon  # turn off flow-control

DIRSTACKSIZE=9
HISTFILE=~/.histfile
HISTSIZE=10000
LISTMAX=0
MAILCHECK=0
REPORTTIME=10
SAVEHIST=$HISTSIZE
TMPPREFIX=$TMP
WATCH="notme"
WATCHFMT="%D %T %b%n%b %a %l from %m"

DIRSTACKFILE=$cachedir/dirstack
if [[ -f $DIRSTACKFILE ]]; then
	dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
	[[ -d $dirstack[1] ]] && cd $dirstack[1] && cs $OLDPWD
fi
chpwd() {
	print -l $PWD ${(u)dirstack} >| $DIRSTACKFILE
}

# exports
export BROWSER=$browser
export EDITOR=$editor
export GREP_COLOR=31
export MANPATH="$MANPATH:/usr/share/man"
export PAGER=$pager
export SUDO_EDITOR=$resticted_editor
export S_COLORS="always"
export TEMP=$TMP
export TMP=$TMP
export TMPDIR=$TMP
export TZ=$timezone
export TIMEZONE=$timezone
export VISUAL=$editor

# options
setopt auto_pushd
setopt pushd_minus
setopt pushd_silent
setopt pushd_to_home
setopt pushd_ignore_dups
setopt auto_param_slash
setopt complete_in_word
setopt hash_list_all
setopt list_types
setopt bad_pattern
setopt equals
setopt extended_glob
setopt no_glob_dots
setopt nonomatch
setopt extended_history
setopt hist_allow_clobber
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt inc_append_history
setopt share_history
setopt noclobber
setopt noflowcontrol  # stty should have done this already
setopt interactive_comments
setopt long_list_jobs
setopt nohup
setopt notify
setopt prompt_subst
setopt prompt_percent
setopt beep

# modules
autoload -U colors zsh/terminfo
colors
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
autoload -Uz zmv
autoload -Uz zsh/sched
autoload -U select-word-style
select-word-style bash
zmodload zsh/datetime
autoload run-help

# aliases
alias dfl="df -hl --exclude tmpfs --exclude devtmpfs --total"
alias dtr="tree -CFd"
alias dt="tree -pugsh --dirfirst -L 1"
alias grep="grep -nH --color=auto"
alias h="history"
alias http="http --style monokai"
alias j="jobs"
alias killall="pkill"
alias ls="ls --color=auto --group-directories-first --classify --time-style='+%Y-%m-%d %H:%M' --human-readable -X"
alias ll="ls -la"
alias mt="multitail --follow-all"
alias nv="nvim"
alias psa="ps --forest -e --sort uid"
alias psc="ps xawf -eo pid,user,cgroup,args"
alias pse="ps -ef"
alias pt="pstree -lnG"
alias pta="pstree -lapG"
alias s="ssh -4"
alias sls="sudo salt"
alias tf="tail -f"
alias tree="tree -CF"
alias watch="watch --color"
alias xi="sudo xbps-install"
alias xq="sudo xbps-query"
alias spm="sudo pacman"
alias sc="sudo systemctl"
alias jc="sudo journalctl"
alias jf="sudo journalctl -f"
[[ -x /usr/bin/xstow ]] && alias stow="xstow"

# completions
autoload -U compinit
zmodload zsh/complist
compinit -d $cachedir/zcompdump

_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1
}

zstyle ':completion:::::' completer _force_rehash _complete
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 )) )'
zstyle ':completion:*' cache-path $cachedir
zstyle ':completion:*' use-cache on
zstyle ':completion:*' force-list always
zstyle ':completion:*:corrections' format "- %d - (errors %e})"
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:descriptions' format "- %d -"
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true
zstyle ':completion:*:man:*' menu yes select
zstyle ':completion:*:default' list-colors 'di=1;34'

zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:*:*:*:processes' command "ps a -o pid,user,comm,command -w -w"
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:kill:*' menu yes select
zstyle ':completion:*:kill:*:processes' list-colors "=(#b) #([0-9]#) #([a-z]#)*=37=31=33"

# prompt
rs="%{k%f%}"
pathcolor="%{%F{166}%}"
usercolor="%{%F{051}%}"
sepcolor="%{%F{240}%}"
exitcolor="%{%F{196}%}"
hostcolot="%{%K{100}%F{190}%}"
userprompt="${usercolor}%n${rs}${sepcolor}@${rs}"
hostprompt="${hostcolor}%m${rs}"
pathprompt="${pathcolor}%5(c:...:)%4c${rs}"
PS1="${userprompt}${hostprompt} ${pathprompt} "
PS2="%{%F{198}%}%_${rs} %{%F{004%}>%{%F{025}%}>%{%F{033}%}>${rs} "
exitprompt="%(?..${exitcolor}%?)"
RPROMPT="${exitprompt}"

# functions
px() { ps uwwp ${$(pgrep -d, "${(j:|:)@}"):?no matches} }
hl() { egrep --color=always -e '' -e${^*} }
mkcd() { mkdir -p "$1" && cd "$1" }
compdef mkcd=mkdir
pstop() { ps -eo pid,user,pri,ni,vsz,rsz,stat,pcpu,pmem,time,comm --sort -pcpu | head -11 }

# keyboard
autoload zkbd
typeset -g -A key
key[F1]='^[[11~'
key[F2]='^[[12~'
key[F3]='^[[13~'
key[F4]='^[[14~'
key[F5]='^[[15~'
key[F6]='^[[17~'
key[F7]='^[[18~'
key[F8]='^[[19~'
key[F9]='^[[20~'
key[F10]='^[[21~'
key[F11]='^[[23~'
key[F12]='^[[24~'
key[Backspace]='^?'
key[Insert]='^[[2~'
key[Home]='^[[7~'
key[PageUp]='^[[5~'
key[Delete]='^[[3~'
key[End]='^[[8~'
key[PageDown]='^[[6~'
key[Up]='^[[A'
key[Left]='^[[D'
key[Down]='^[[B'
key[Right]='^[[C'
key[Menu]=''''
[[ -n ${key[Left]}      ]] && bindkey "${key[Left]}"      backward-char
[[ -n ${key[Right]}     ]] && bindkey "${key[Right]}"     forward-char
[[ -n ${key[Up]}        ]] && bindkey "${key[Up]}"        up-line-or-history
[[ -n ${key[Down]}      ]] && bindkey "${key[Down]}"      down-line-or-history
[[ -n ${key[Home]}      ]] && bindkey "${key[Home]}"      beginning-of-line
[[ -n ${key[End]}       ]] && bindkey "${key[End]}"       end-of-line
[[ -n ${key[PageUp]}    ]] && bindkey "${key[PageUp]}"    history-beginning-search-backward
[[ -n ${key[PageDown]}  ]] && bindkey "${key[PageDown]}"  history-beginning-search-forward
[[ -n ${key[Delete]}    ]] && bindkey "${key[Delete]}"    delete-char
[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char

# done
fotune -a
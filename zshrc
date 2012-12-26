# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=100000
setopt appendhistory autocd extendedglob
setopt EXTENDED_HISTORY # puts timestamps in the history



BLACK="%{"$'\033[01;30m'"%}"
GREEN="%{"$'\033[01;32m'"%}"
RED="%{"$'\033[01;31m'"%}"
YELLOW="%{"$'\033[01;33m'"%}"
BLUE="%{"$'\033[01;34m'"%}"
BOLD="%{"$'\033[01;39m'"%}"
NORM="%{"$'\033[00m'"%}"

autoload -Uz vcs_info

# prompt (if running screen, show window #)
if [ x$WINDOW != x ]; then
    export PS1="$WINDOW:%~%# "
else
      export PS1="
<${YELLOW}%~${NORM}>
${RED}%n${YELLOW}@${BLUE}%U%m%u$%(!.#.$) "
    #export PS1="[${RED}%n${YELLOW}@${BLUE}%U%m%u$:${GREEN}%2c${NORM}]%(!.#.$) "
    #right prompt - time/date stamp
    #export RPS1="${GREEN}(%D{%m-%d %H:%M})${NORM}"
    # this right prompt is for any kind of repository info - svn, git, mercurial ,etc. courtesy of vcs_info
    export RPS1="${YELLOW}%1v${NORM}"
fi

# format titles for screen and rxvt
function title() {
  # escape '%' chars in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
  screen)
    print -Pn "\ek$a:$3\e\\" # screen title (in ^A")
    ;;
  xterm*|rxvt)
    print -Pn "\e]2;$2 | $a:$3\a" # plain xterm title
    ;;
  esac
}

# precmd is called just before the prompt is printed
function precmd() {
  title "zsh" "$USER@%m" "%55<...<%~"
  psvar=()
  vcs_info
  [[ -n $vcs_info_msg_0_ ]] && psvar[1]="$vcs_info_msg_0_"
}

# preexec is called just before any command line is executed
function preexec() {
  title "$1" "$USER@%m" "%35<...<%~"
}

# this is ubuntu specific - in case you execute a command
# that is not installed, zsh automatically calls this handler
# so that you get a nice recommendation message (similar to bash)
function command_not_found_handler() {
     /usr/bin/python /usr/lib/command-not-found -- $1
}

# vi editing
# this prevents me from deleting a word using ESC-Backspace
#bindkey -v

# colorful listings
zmodload -i zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

autoload -U compinit
compinit

# aliases
alias emacs='emacs -nw'
alias mv='nocorrect mv' # no spelling correction on mv
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias j=jobs
if ls -F --color=auto >&/dev/null; then
  alias l="ls --color=auto -F"
  alias ls="ls --color=auto"
  alias la="ls --color=auto -a"
  alias ll="ls --color=auto -l"
  alias lla="ls --color=auto -la" 
else
  alias l="ls -F"
  alias ls="ls -F"
  alias la="ls -a"
  alias ll="ls -l"
  alias lla="ls -la"
fi
alias ..='cd ..'
alias .='pwd'
alias grep='grep -E --color=always'

export SBCL_HOME=/home/user/research/lisp/sbcl-1.0.29/release/lib/sbcl/
export SCALA_HOME=/usr
# for webcam
export XLIB_SKIP_ARGB_VISUALS=1
alias sbcl='/home/user/research/lisp/sbcl-1.0.29/release/bin/sbcl'
export SBCL_HOME=/home/user/research/lisp/sbcl-1.0.29/release/lib/sbcl/

#copy with progress bar
alias cp='rsync -aP'
alias netstat='netstat -ap'



#variables that need to be set for intellij - Ubuntu
export JDK_HOME=/usr/lib/jvm/java-6-sun-1.6.0.15/
export M2_HOME=/usr/share/maven2/

# functions
setenv() { export $1=$2 } # csh compatibility

#bash style ctrl-a (beginning of line) and ctrl-e (end of line)
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
# key bindings

# Emulate tcsh's backward-delete-word
tcsh-backward-delete-word () {
    #local WORDCHARS="${WORDCHARS:s#/#}"
    #local WORDCHARS='*?_[]~\/!#$%^<>|`@#$%^*()+?'
    local WORDCHARS="${WORDCHARS:s#/#}"
    zle backward-delete-word
}

tcsh-backward-word () {
    local WORDCHARS="${WORDCHARS:s#/#}"
    zle emacs-backward-word
}

tcsh-forward-word () {
    local WORDCHARS="${WORDCHARS:s#/#}"
    zle emacs-forward-word
}

zle -N tcsh-backward-delete-word
zle -N tcsh-backward-word
zle -N tcsh-forward-word

# for escape backspace (delete a word) behavior similar to tcsh
bindkey '\e^?' tcsh-backward-delete-word
#for ctrl leftarrow and rightarrow navigation
bindkey ';5D' tcsh-backward-word
bindkey ';5C' tcsh-forward-word

#if this is uncommented, it will ignore the stop-at-special-chars
#bindkey '\e^H' backward-delete-word


#linux TTY optimization fix
#mkdir -m 0700 /dev/cgroup/cpu/user/$$
#echo $$ > /dev/cgroup/cpu/user/$$/tasks

# Some useful aliases.
alias comp="docker compose"
alias ..="cd .."

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias gb='git branch'
alias gc='git checkout'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Dotenv
dotenv() {
    export $(grep -v "^#" .env | xargs)
}

unset_dotenv() {
    unset $(grep -v '^#' .env | sed -E 's/(.*)=.*/\1/' | xargs)
}

#
# Csh compatibility:
#
alias unsetenv=unset
function setenv() {
    export $1="$2"
}

# Function which adds an alias to the current shell and to
# the ~/.bash_aliases file.
add-alias() {
    local name=$1 value="$2"
    echo alias $name=\'$value\' >>~/.bash_aliases
    eval alias $name=\'$value\'
    alias $name
}

# "repeat" command.  Like:
#
#	repeat 10 echo foo
repeat() {
    local count="$1" i
    shift
    for i in $(_seq 1 "$count"); do
        eval "$@"
    done
}

# Subfunction needed by `repeat'.
_seq() {
    local lower upper output
    lower=$1 upper=$2

    if [ $lower -ge $upper ]; then return; fi
    while [ $lower -lt $upper ]; do
        echo -n "$lower "
        lower=$(($lower + 1))
    done
    echo "$lower"
}

# Options
set -o vi

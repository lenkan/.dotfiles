# Some useful aliases.
alias comp="docker compose"
alias ..="cd .."
alias updatetime="sudo ntpdate ntp.ubuntu.com"

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
alias n='npm run'
alias open='xdg-open'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Dotenv
dotenv() {
    file=${1:-.env}
    if [ ! -f $file ]; then
        echo "File $file not found"
        return 1
    fi
    
    export $(grep -v '^#' $file | xargs)
}

unset_dotenv() {
    file=${1:-.env}
    if [ ! -f $file ]; then
        echo "File $file not found"
        return 1
    fi

    unset $(grep -v '^#' $file | sed -E 's/(.*)=.*/\1/' | xargs)
}

# Options
set -o vi

# shellcheck shell=bash
# Some useful aliases.
alias comp="docker compose"
alias ..="cd .."
alias updatetime="sudo ntpdate ntp.ubuntu.com"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	if test -r ~/.dircolors; then
		eval "$(dircolors -b ~/.dircolors)"
	else
		eval "$(dircolors -b)"
	fi
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
alias nn='npm run'
alias open='xdg-open'

# Dotenv
dotenv() {
	file=${1:-.env}
	if [ ! -f "$file" ]; then
		echo "File $file not found"
		return 1
	fi

	# shellcheck disable=SC2046
	export $(grep -v '^#' "$file" | xargs)
}

unset_dotenv() {
	file=${1:-.env}
	if [ ! -f "$file" ]; then
		echo "File $file not found"
		return 1
	fi

	# shellcheck disable=SC2046
	unset $(grep -v '^#' "$file" | sed -E 's/(.*)=.*/\1/' | xargs)
}

# Options
set -o vi

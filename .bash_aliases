# shellcheck shell=bash
# Some useful aliases.
alias comp="docker compose"
alias ..="cd .."
# WSL clock drifts after the host sleeps; resync from the hardware clock.
alias updatetime="sudo hwclock -s"

# dircolors means GNU coreutils, whose ls supports --color
if command -v dircolors >/dev/null; then
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias gb='git branch'
alias gc='git checkout'
alias gd='git difftool -d'
alias n='npm run'
alias nn='npm run'
alias p='pnpm'
alias pi='pnpm install'
alias pp='pnpm run'
alias k='kubectl'
alias kk='kubectl'

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

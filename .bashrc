#!/bin/bash
# shellcheck disable=SC1090,SC1091
PATH="$HOME/.local/bin:$PATH"
# Homebrew before /usr/bin: Apple's git etc. don't ship bash completions
if [ -x /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv bash)"
fi

case $- in
*i*) ;;
*) return ;;
esac

HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=100000
# Share history between open terminals: save, then reload, before each prompt
PROMPT_COMMAND="history -a; history -c; history -r"
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
set -o vi

# Source a command's output, cached until its binary changes (rm -rf ~/.cache/bash to refresh)
_cached_eval() {
	local bin cache
	bin=$(command -v "$1") || return 0
	cache="${XDG_CACHE_HOME:-$HOME/.cache}/bash/$1.bash"
	if [ ! -s "$cache" ] || [ "$bin" -nt "$cache" ]; then
		mkdir -p "${cache%/*}"
		"$@" >"$cache" 2>/dev/null || {
			rm -f "$cache"
			return 0
		}
	fi
	. "$cache"
}

if command -v lesspipe >/dev/null; then
	eval "$(SHELL=/bin/sh lesspipe)"
fi

if command -v dircolors >/dev/null; then
	if [ -r "$HOME/.dircolors" ]; then
		eval "$(dircolors -b "$HOME/.dircolors")"
	else
		eval "$(dircolors -b)"
	fi
fi

if [ -f "$HOME/.bash_aliases" ]; then
	. "$HOME/.bash_aliases"
fi

if [ -f "$HOME/.bash_prompt" ]; then
	. "$HOME/.bash_prompt"
fi

if command -v fnm >/dev/null; then
	eval "$(fnm env --use-on-cd --shell bash)"
fi

if [ -d "$HOME/.deno" ]; then
	PATH="$HOME/.deno/bin:$PATH"
fi

if [ -d /usr/local/go ]; then
	PATH="/usr/local/go/bin:$PATH"
fi

if [ -d "$HOME/.opencode" ]; then
	PATH="$HOME/.opencode/bin:$PATH"
fi

# pnpm comes from corepack via fnm, so check the command, not PNPM_HOME
if command -v pnpm >/dev/null; then
	export PNPM_HOME="$HOME/.local/share/pnpm"
	PATH="$PNPM_HOME/bin:$PATH"
fi

if [ -f "$HOME/.cargo/env" ]; then
	. "$HOME/.cargo/env"
fi

if command -v nvim >/dev/null; then
	export EDITOR='nvim'
	export VISUAL='nvim'
fi

# Before completions so they pick up its aliases and PATH
if [ -f "$HOME/.bashrc.local" ]; then
	. "$HOME/.bashrc.local"
fi

if [ ! -S "${SSH_AUTH_SOCK:-}" ] && command -v keychain >/dev/null; then
	eval "$(keychain --eval)"
fi

# Completions
if ! shopt -oq posix; then
	# Without the HOMEBREW_PREFIX check this would match Fedora's /etc/profile.d
	if [ -n "${HOMEBREW_PREFIX:-}" ] && [ -f "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
		. "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
	elif [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi

	if [ -f "$HOME/.dotfiles/complete_alias.bash" ]; then
		. "$HOME/.dotfiles/complete_alias.bash"
	fi
fi

if command -v aws_completer >/dev/null; then
	complete -C aws_completer aws
fi
_cached_eval deno completions bash
_cached_eval pnpm completion bash
_cached_eval npm completion
_cached_eval node --completion-bash
_cached_eval uv generate-shell-completion bash
# Keep last: the first prompt is red if .bashrc ends on a failed command
complete -F _complete_alias "${!BASH_ALIASES[@]}"

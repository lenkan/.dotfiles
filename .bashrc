# ~/.bashrc: executed by bash(1) for non-login shells.
PATH=$PATH:~/.local/bin

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi

  if [ -f ~/.dotfiles/complete_alias.bash ]; then
    . ~/.dotfiles/complete_alias.bash
  fi
fi

if [ -d ~/.nvm ]; then
  export NVM_DIR="$HOME/.nvm"

  if [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"
  fi

  if [ -s "$NVM_DIR/bash_completion" ]; then
    . "$NVM_DIR/bash_completion"
  fi
fi

if [ -d ~/.deno ]; then
  DENO_INSTALL="~/.deno"
  PATH="$DENO_INSTALL/bin:$PATH"
  eval "$(deno completions bash)"
fi

if [ -d /usr/local/go ]; then
  PATH="/usr/local/go/bin:$PATH"
fi

if [ -d "$HOME/.local/share/pnpm" ]; then
  export PNPM_HOME="/home/lenkan/.local/share/pnpm"
  export PATH="$PNPM_HOME:$PATH"

  alias p='pnpm'
  alias pi='pnpm install'

  eval "$(pnpm completion bash)"
fi

keychain --version &>/dev/null && eval "$(keychain --eval)"
gh --version &>/dev/null && eval "$(gh completion -s bash)"
npm --version &>/dev/null && eval "$(npm completion)"
node --version &>/dev/null && eval "$(node --completion-bash)"
thefuck --version &>/dev/null && eval "$(thefuck --alias)"
copilot --version &>/dev/null && eval "$(copilot completion bash)"
aws --version &>/dev/null && complete -C "$HOME/.local/bin/aws_completer" aws
docker --version &>/dev/null && eval "$(docker completion bash)"
complete -F _complete_alias "${!BASH_ALIASES[@]}"

export EDITOR='vim'
export VISUAL='vim'

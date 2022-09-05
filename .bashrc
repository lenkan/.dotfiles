# ~/.bashrc: executed by bash(1) for non-login shells.
PATH=$PATH:~/.local/bin

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
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

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

[ -f ~/.bash_aliases ] && source ~/.bash_aliases

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

gh --version &> /dev/null && eval "$(gh completion -s bash)"
npm --version &> /dev/null && eval "$(npm completion)"
node --version &> /dev/null && eval "$(node --completion-bash)"
thefuck --version &> /dev/null && eval "$(thefuck --alias)"
copilot --version &> /dev/null && eval "$(copilot completion bash)"
aws --version &> /dev/null && complete -C '/usr/local/bin/aws_completer' aws
complete -F _complete_alias "${!BASH_ALIASES[@]}"

export EDITOR='vim'
export VISUAL='vim'

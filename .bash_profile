# shellcheck shell=bash
# shellcheck source=/dev/null
[ -f ~/.bashrc ] && source ~/.bashrc

# OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.bash 2>/dev/null || :

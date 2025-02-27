#!/usr/bin/env bash
# This file runs every time you open a new terminal window.

set -o emacs

export FORGIT_COPY_CMD="xclip -selection clipboard"

# Limit number of lines and entries in the history. HISTFILESIZE controls the
# history file on disk and HISTSIZE controls lines stored in memory.
export HISTFILESIZE=50000
export HISTSIZE=50000

# Add a timestamp to each command.
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "

# Duplicate lines and lines starting with a space are not put into the history.
export HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it.
shopt -s histappend

# Ensure $LINES and $COLUMNS always get updated.
shopt -s checkwinsize

# Enable bash completion.
[ -f /etc/bash_completion ] && source /etc/bash_completion

# Improve output of less for binary files.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Load aliases if they exist.
[ -f "${HOME}/.aliases" ] && source "${HOME}/.aliases"
[ -f "${HOME}/.aliases.local" ] && source "${HOME}/.aliases.local"

# Determine git branch.
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Set a non-distracting prompt.
PS1='\[[01;32m\]\u@\h\[[00m\]:\[[01;34m\]\w\[[00m\] \[[01;33m\]$(parse_git_branch)\[[00m\]\$ '

export TERMINFO='/usr/share/terminfo/'
export TERM="xterm-color"
# If it's an xterm compatible terminal, set the title to user@host: dir.
case "${TERM}" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]${PS1}"
    ;;
*)
    ;;
esac

# Enable asdf to manage various programming runtime versions.
#   Requires: https://asdf-vm.com/#/
source "${HOME}"/.asdf/asdf.sh

# Enable a better reverse search experience.
#   Requires: https://github.com/junegunn/fzf (to use fzf in general)
#   Requires: https://github.com/BurntSushi/ripgrep (for using rg below)
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export FZF_DEFAULT_OPTS="--color=dark"
[ -f "${HOME}/.fzf.bash" ] && source "${HOME}/.fzf.bash"

# WSL 2 specific settings.
#if grep -q "microsoft" /proc/version &>/dev/null; then
    # Requires: https://sourceforge.net/projects/vcxsrv/ (or alternative)
#    export DISPLAY="$(/sbin/ip route | awk '/default/ { print $3 }'):0"

     # Allows your gpg passphrase prompt to spawn (useful for signing commits).
#    export GPG_TTY=$(tty)
#fi

# WSL 1 specific settings.
# if grep -qE "(Microsoft|WSL)" /proc/version &>/dev/null; then
#     if [ "$(umask)" = "0000" ]; then
#         umask 0022
#     fi

#     # Requires: https://sourceforge.net/projects/vcxsrv/ (or alternative)
#     export DISPLAY=:0
# fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"

[ -f ~/src/forgit/forgit.plugin.sh ] && source ~/src/forgit/forgit.plugin.sh

[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && source ~/.autojump/etc/profile.d/autojump.sh

[ -f ~/.functions ] && source ~/.functions

export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
export LIBGL_ALWAYS_INDIRECT=1

export PATH=~/bin:"${PATH}"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source ~/.venv/bin/activate

set -x CLASSPATH ".:~/src/antlr-4.9.2-complete.jar:$CLASSPATH"

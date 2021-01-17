umask 002

setopt AUTO_PUSHD

alias tf='tail -f'
alias lla='ls -la --color'
alias ll='ls -l --color'
alias li='ls -la --color'
alias ...='cd ../..'
alias ..='cd ..'
alias tb="nc termbin.com 9999"
####################
# The following lines were added by compinstall

autoload -Uz compinit
compinit
# End of lines added by compinstall

export HISTFILE=~/.zsh_history
export SAVEHIST=10000
export HISTSIZE=10000


PROMPT=$'%{\e[0;32m%}[%{\e[0;33m%}%T %{\e[0;32m%}%m: %{$fg[cyan]%}%~%{\e[0;32m%}] %{\e[1;31m%}%(?.%{\e[0;32m%}.%{\e[1;31m%})%#%{\e[0m%} '

# install oh-my-zsh: sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# If command execution time above min. time, plugins will not output time.
ZSH_COMMAND_TIME_MIN_SECONDS=3
# Message to display (set to "" for disable).
ZSH_COMMAND_TIME_MSG="Execution time: %s "

# Message color.
ZSH_COMMAND_TIME_COLOR="cyan"

# Exclude some commands
ZSH_COMMAND_TIME_EXCLUDE=(vim mcedit)

function nonzero_return() {
        RETVAL=$?
        [ $RETVAL -ne 0 ] && echo "$RETVAL"
}


export ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

plugins=(git docker dotenv history rsync command-time)

source $ZSH/oh-my-zsh.sh



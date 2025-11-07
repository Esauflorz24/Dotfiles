#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='lsd'
alias l='lsd -lh'
alias ll='lsd -lah'
alias la='lsd -A'
alias lm='lsd -m'
alias lr='lsd -R'
alias lg='lsd -l --group-directories-first'
alias cat="bat"
alias vi='nvim'


# git
alias gcl='git clone --depth 1'
alias gi='git init'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'

eval "$(starship init bash)"

PS1='[\u@\h \W]\$ '

export EDITOR=nvim


source /home/esz/.local/share/blesh/ble.sh --noattach --rcfile ~/.config/blesh/blerc
source /usr/share/nvm/init-nvm.sh



[[ ! ${BLE_VERSION-} ]] || ble-attach

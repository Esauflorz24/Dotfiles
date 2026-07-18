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

cisco() {
    /usr/lib/packettracer/packettracer.AppImage >/dev/null 2>&1 &
    disown
}

pdfread() {
    
    if (($# == 0)); then
        echo "Uso: pdfread archivo.pdf"
	return 1
    fi

    
    if [ $# -gt 1 ]; then
        echo "Error, numero de argumentos incorrecto"
	return 1
    fi

    file="$1"

    if ! [ -s "$file" ]; then
        echo "El archivo no existe"
	return 1
    fi

    file_extension="${file##*.}"
    if [ "${file_extension,,}" != "pdf" ]; then
        echo "Solo se admite archivos .pdf"
	return 1
    fi

    zathura "$file" >/dev/null 2>&1 &
    disown

}
source /home/esz/.local/share/blesh/ble.sh --noattach --rcfile ~/.config/blesh/blerc
source /usr/share/nvm/init-nvm.sh

[[ ! ${BLE_VERSION-} ]] || ble-attach

. "$HOME/.local/bin/env"

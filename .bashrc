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
    if ! [ -e "/usr/lib/packettracer/packettracer.AppImage" ]; then
        echo "cisco packet tracer no esta instalado"
        return 1
    fi

    /usr/lib/packettracer/packettracer.AppImage >/dev/null 2>&1 &
    disown
}

pdfread() {
    if ! command -v zathura >/dev/null; then
        echo "Zathura no está instalado"
        return 1
    fi

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
    if [ "${file_extension,,}" != "pdf" ] && [ "${file_extension,,}" != "epub" ]; then
        echo "formato de archivo incorrecto"
        return 1
    fi

    zathura "$file" >/dev/null 2>&1 &
    disown

}
target() {

    temp_file="/tmp/targets.txt"
    ip_regex="^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
    max_arguments=1
    empty_arguments=0
    ip_target="$1"

    # Comprobación si el programa "notify-send" existe
    if ! command -v notify-send >/dev/null; then
        echo "Notify send no esta instalado"
        return 1
    fi

    # Comprobacion si el archivo temporal existe
    if ! [ -e "$temp_file" ]; then
        touch "$temp_file"

    fi

    # Comprobación si no hay ningun argumento
    if [[ $# -eq $empty_arguments ]]; then
        echo "Uso: target [direccion ip]"
        return 1
    fi

    # Comprobación el numero de argumentos se excede de 1
    if [ $# -gt $max_arguments ]; then
        echo "Cantidad de parametros incorrecta"
        return 1
    fi

    # Comprobación para que la IP tenga un formato correcto
    if ! echo "$ip_target" | grep -qP "$ip_regex"; then
        echo "Formato incorrecto, $1 no es una IP"
        return 1
    fi

    # Guardando la ip en el archivo temporal
    echo "$ip_target" >>"$temp_file"

    # Notificacion indicando la IP guardada
    notify-send "IP guardada" "Objetivo 󰈈 : $ip_target"
}
source /home/esz/.local/share/blesh/ble.sh --noattach --rcfile ~/.config/blesh/blerc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

[[ ! ${BLE_VERSION-} ]] || ble-attach

export PATH="${PATH}:/home/esz/bin"

# uv
export PATH="/home/esz/.local/bin:$PATH"

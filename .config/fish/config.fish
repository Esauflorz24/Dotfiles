set fish_greeting ""
fish_vi_key_bindings

# Aliases
alias ls='lsd'
alias l='lsd -lh'
alias ll='lsd -lah'
alias la='lsd -A'
alias lm='lsd -m'
alias lr='lsd -R'
alias lg='lsd -l --group-directories-first'
alias cat="bat"

# git
alias gcl='git clone --depth 1'
alias gi='git init'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push origin master'



starship init fish | source



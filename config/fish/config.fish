# Fish config

# disable greeting
set fish_greeting ""

set -gx TERM xterm-256color

# Alias
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g git
command -qv nvim && alias vim nvim

switch (uname)
    case Linux
        source (dirname (status --current-filename))/linux.fish
end

set LOCAL_CONFIG (dirname (status --current-filename))/local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end

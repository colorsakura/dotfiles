# Fish config

# disable greeting
set fish_greeting ""

set -gx TERM xterm-256color
# set -U fish_emoji_width 2 # fix terminal file manager icons

# Alias
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g git
command -qv nvim && alias vim nvim

if status --is-interactive

end

switch (uname)
    case Linux
        source (dirname (status --current-filename))/linux.fish
end

set LOCAL_CONFIG (dirname (status --current-filename))/local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end

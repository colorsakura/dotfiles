# disable greeting
set fish_greeting ""

set -gx TERM xterm-256color
set -U fish_emoji_width 2 # fix terminal file manager icons

# Warp terminal subshell
if status is-interactive
    printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish"}}\x9c'
end

switch (uname)
    case Linux
        source (dirname (status --current-filename))/linux.fish
    case Darwin
end

set LOCAL_CONFIG (dirname (status --current-filename))/local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end

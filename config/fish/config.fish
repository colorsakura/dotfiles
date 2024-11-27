# disable greeting
set fish_greeting ""

if type -q git
    alias g git
end

switch (uname)
    case Linux
        source (dirname (status --current-filename))/linux.fish
    case Darwin
        source (dirname (status --current-filename))/macos.fish
end

set LOCAL_CONFIG (dirname (status --current-filename))/local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end

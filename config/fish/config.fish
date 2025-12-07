# Disable greeting
set fish_greeting ""

# Enable vi mode
fish_vi_key_bindings

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
# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

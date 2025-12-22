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

if status is-interactive

    # --------------------------
    # Shell Enhancement Tools
    # --------------------------
    # Zoxide smart cd
    if type -q zoxide
        zoxide init fish | source
    end

    # Fuzzy finder
    if type -q fzf
        fzf --fish | source
        set -x FZF_DEFAULT_COMMAND 'fd --type file'
        set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    end

    # Shell history enhancement
    if type -q atuin
        atuin init fish --disable-up-arrow | source
    end

    # Environment management
    if type -q direnv
        direnv hook fish | source
    end
end

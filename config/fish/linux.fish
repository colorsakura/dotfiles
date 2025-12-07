# --------------------------
# XDG Path
# --------------------------
superset XDG_CACHE_HOME $HOME/.cache
superset XDG_CONFIG_HOME $HOME/.config
superset XDG_DATA_HOME $HOME/.local/share
superset XDG_STATE_HOME $HOME/.local/state

# --------------------------
# Editor
# --------------------------
if type -q nvim
    superset EDITOR nvim
    superset VISUAL nvim
    superset MANPAGER 'nvim +Man!'

    alias nv nvim
    alias vi 'nvim --clean'
else
    superset EDITOR nvim
    superset VISUAL nvim
end

# --------------------------
# GPG
# --------------------------
[ -d "$XDG_DATA_HOME"/gnupg ] || mkdir -m 700 -p "$XDG_DATA_HOME/gnupg"
set -x GNUPGHOME "$XDG_DATA_HOME"/gnupg


# --------------------------
# Development
# --------------------------
# Golang
set -x GO111MODULE on
set -x GOPATH "$XDG_DATA_HOME"/go
set -x GOPROXY "https://goproxy.cn,direct"
fish_add_path $GOPATH/bin
# Rust
set -x CARGO_HOME "$XDG_DATA_HOME"/cargo
set -x RUSTUP_HOME "$XDG_DATA_HOME"/rustup
# rustup bootstrap
set -x RUSTUP_UPDATE_ROOT https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
set -x RUSTUP_DIST_SERVER https://mirrors.tuna.tsinghua.edu.cn/rustup
# Python
set -x IPYTHONDIR "$XDG_CONFIG_HOME"/jupyter
set -x JUPYTER_CONFIG_DIR "$XDG_CONFIG_HOME"/jupyter
# Ruby
set -x BUNDLE_PATH $XDG_DATA_HOME/bundle
# Flutter
set -x PUB_HOSTED_URL "https://mirrors.tuna.tsinghua.edu.cn/dart-pub"
set -x FLUTTER_STORAGE_BASE_URL "https://mirrors.tuna.tsinghua.edu.cn/flutter"

# Fcitx5
if [ "$XDG_SESSION_DESKTOP" != KDE ]
  set -x GLFW_IM_MODULE fcitx # ibus|fcitx
  set -x GTK_IM_MODULE fcitx # wayland|fcitx
  set -x INPUT_METHOD fcitx
  set -x QT_IM_MODULE fcitx
  set -x SDL_IM_MODULE fcitx
  set -x XMODIFIERS @im=fcitx
end

# Enable Wayland
set -x XDG_SESSION_TYPE wayland
if [ "$XDG_SESSION_TYPE" = wayland ]
    set -x ANKI_WAYLAND 1 # Anki wayland
    set -x CLUTTER_BACKEND wayland
    set -x MOZ_ENABLE_WAYLAND 1 # Firefox wayland
    set -x QT_QPA_PLATFORM wayland
    set -x SDL_VIDEODRIVER wayland
    set -x WINIT_UNIX_BACKEND wayland
end


# --------------------------
# Jetbrains APPS hack plugin
# --------------------------
if test -e "~/.jetbrains.vmoptions.sh"
    source "~/.jetbrains.vmoptions.sh"
end

# --------------------------
# Add paths and reorder them
# --------------------------
if not type -q fish_add_path
    function fish_add_path
        contains $argv $fish_user_paths; or set -Ua fish_user_paths $argv
    end
end

fish_add_path $HOME/.local/bin
fish_add_path $GOPATH/bin
fish_add_path $CARGO_HOME/bin
fish_add_path $XDG_CACHE_HOME/.bun/bin # bun global
fish_add_path $XDG_DATA_HOME/SDK/flutter/bin

# 交互模式
if status is-interactive
    if type -q starship
        starship init fish | source
    end

    if type -q zoxide
        zoxide init fish | source
    end

    if type -q fzf
        fzf --fish | source
        set -x FZF_DEFAULT_COMMAND 'fd --type file'
        set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    end

    if type -q atuin
        atuin init fish --disable-up-arrow | source
    end

    if type -q direnv
        direnv hook fish | source
    end
end
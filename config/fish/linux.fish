# Editor
set -gx EDITOR (which nvim)
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR

set -gx GPG_TTY (tty)

# Alias
if type -q eza
    alias ls eza
    alias ll "eza -l -g --icons"
    alias lla "ll -a"
end

# XDG Path
set -Ux fish_user_paths
set -x XDG_CACHE_HOME $HOME/.cache
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_STATE_HOME $HOME/.local/state

# GPG
[ -d "$XDG_DATA_HOME"/gnupg ] || mkdir -m 700 -p "$XDG_DATA_HOME/gnupg"
set -x GNUPGHOME "$XDG_DATA_HOME"/gnupg

# Golang
set -x GOPATH "$XDG_DATA_HOME"/go
# Rust
set -x CARGO_HOME "$XDG_DATA_HOME"/cargo
set -x RUSTUP_HOME "$XDG_DATA_HOME"/rustup
# rustup bootstrap
set -x RUSTUP_UPDATE_ROOT https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
set -x RUSTUP_DIST_SERVER https://mirrors.tuna.tsinghua.edu.cn/rustup
# Python
set -x IPYTHONDIR "$XDG_CONFIG_HOME"/jupyter
set -x JUPYTER_CONFIG_DIR "$XDG_CONFIG_HOME"/jupyter
# set python3.11 PYTHONPATH for neovim
set -x PYTHONPATH ~/.local/lib/python3.11/site-packages
set -x PYTHONPATH /usr/lib/python3.11/site-packages $PYTHONPATH
# Ruby
set -x BUNDLE_PATH $XDG_DATA_HOME/bundle

# 环境变量
fish_add_path $GOPATH/bin
fish_add_path $CARGO_HOME/bin
fish_add_path $HOME/.local/bin
fish_add_path $XDG_CONFIG_HOME/rofi/scripts
fish_add_path $XDG_DATA_HOME/gem/ruby/3.0.0/bin

# Fcitx5
set -x GLFW_IM_MODULE ibus # ibus|fcitx
set -x GTK_IM_MODULE fcitx # wayland|fcitx
set -x INPUT_METHOD fcitx
set -x QT_IM_MODULE fcitx
set -x SDL_IM_MODULE fcitx
set -x XMODIFIERS @im=fcitx

# Enable Wayland
set -x XDG_SESSION_TYPE wayland
if [ "$XDG_SESSION_TYPE" = wayland ]
    set -x ANKI_WAYLAND 1 # Anki wayland
    set -x CLUTTER_BACKEND wayland
    set -x MOZ_ENABLE_WAYLAND 1 # Firefox wayland
    set -x QT_QPA_PLATFORM wayland
    set -x SDL_VIDEODRIVER wayland
    # set -x WINIT_UNIX_BACKEND wayland
end

# use en_US for fontconfig
set -x LC_CTYPE en_US.UTF-8

# Jetbrains APPS plugin
if [ -f "$HOME/.jetbrains.vmoptions.sh" ]
    source ~/.jetbrains.vmoptions.sh
end

# 切记在设置环境变量后运行
# after login in tty, auto run wm;
if status --is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        if which sway >/dev/null 2>&1
            set -x XDG_CURRENT_DESKTOP sway
            set -x WLR_RENDERER vulkan
            exec sway
        end
    end
end

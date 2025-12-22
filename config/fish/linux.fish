# --------------------------
# XDG Base Directory Specification
# --------------------------
# Use XDG directories for configuration, data, cache, and state
# See: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
if not set -q XDG_CACHE_HOME
    superset XDG_CACHE_HOME $HOME/.cache
end
if not set -q XDG_CONFIG_HOME
    superset XDG_CONFIG_HOME $HOME/.config
end
if not set -q XDG_DATA_HOME
    superset XDG_DATA_HOME $HOME/.local/share
end
if not set -q XDG_STATE_HOME
    superset XDG_STATE_HOME $HOME/.local/state
end

# --------------------------
# Editor Configuration
# --------------------------
# Set default editor to neovim if available
if type -q nvim
    superset EDITOR nvim
    superset VISUAL nvim
    superset MANPAGER 'nvim +Man!'

    # Define convenient aliases for neovim
    alias nv nvim
    alias vi 'nvim --clean'
else
    # Fallback to vim if neovim is not available
    if type -q vim
        superset EDITOR vim
        superset VISUAL vim
        alias nv vim
        alias vi vim
    else
        # Use system default if neither vim nor nvim are available
        superset EDITOR vi
        superset VISUAL vi
    end
end

# --------------------------
# GPG Configuration
# --------------------------
# Ensure GPG home directory exists with secure permissions
set -l gnupg_dir "$XDG_DATA_HOME/gnupg"
if not test -d "$gnupg_dir"
    mkdir -m 700 -p "$gnupg_dir"
    echo "Created GPG home directory with secure permissions: $gnupg_dir"
end
set -x GNUPGHOME "$gnupg_dir"

# --------------------------
# Development Environment Configuration
# --------------------------

# Go Language
if type -q go
    set -x GO111MODULE on
    set -x GOPATH "$XDG_DATA_HOME/go"
    set -x GOPROXY "https://goproxy.cn,direct"
    fish_add_path $GOPATH/bin
end

# Rust
if type -q rustc
    set -x CARGO_HOME "$XDG_DATA_HOME/cargo"
    set -x RUSTUP_HOME "$XDG_DATA_HOME/rustup"
    # Configure rustup to use Tsinghua mirror
    set -x RUSTUP_UPDATE_ROOT https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
    set -x RUSTUP_DIST_SERVER https://mirrors.tuna.tsinghua.edu.cn/rustup
end

# Python
set -x IPYTHONDIR "$XDG_CONFIG_HOME/jupyter"
set -x JUPYTER_CONFIG_DIR "$XDG_CONFIG_HOME/jupyter"

# Ruby
set -x BUNDLE_PATH $XDG_DATA_HOME/bundle

# Flutter
set -x PUB_HOSTED_URL "https://mirrors.tuna.tsinghua.edu.cn/dart-pub"
set -x FLUTTER_STORAGE_BASE_URL "https://mirrors.tuna.tsinghua.edu.cn/flutter"

# Fcitx5 Input Method
# Only configure if not using KDE (which typically uses kwin and its own input method)
if test "$XDG_SESSION_DESKTOP" != KDE
    set -x GLFW_IM_MODULE fcitx
    set -x GTK_IM_MODULE fcitx
    set -x INPUT_METHOD fcitx
    set -x QT_IM_MODULE fcitx
    set -x SDL_IM_MODULE fcitx
    set -x XMODIFIERS @im=fcitx
end

# Wayland Support
set -x XDG_SESSION_TYPE wayland
if test "$XDG_SESSION_TYPE" = wayland
    # Enable Wayland support for various applications
    set -x ANKI_WAYLAND 1
    set -x CLUTTER_BACKEND wayland
    set -x MOZ_ENABLE_WAYLAND 1
    set -x QT_QPA_PLATFORM wayland
    set -x SDL_VIDEODRIVER wayland
    set -x WINIT_UNIX_BACKEND wayland
end

# --------------------------
# Jetbrains APPS Configuration
# --------------------------
set -l jetbrains_config "$HOME/.jetbrains.vmoptions.sh"
if test -e "$jetbrains_config"
    source "$jetbrains_config"
end

# Interactive Session Configuration
if status is-interactive
    # --------------------------
    # Path Configuration
    # --------------------------
    # Ensure fish_add_path function exists
    if not type -q fish_add_path
        function fish_add_path
            contains $argv $fish_user_paths; or set -Ua fish_user_paths $argv
        end
    end

    # Add user-local binaries to PATH
    fish_add_path $HOME/.local/bin

    # Add development tool paths if the tools exist
    if type -q go
        fish_add_path $GOPATH/bin
    end

    if type -q cargo
        fish_add_path $CARGO_HOME/bin
    end

    # Add bun and flutter paths if they exist
    if test -d "$XDG_CACHE_HOME/.bun/bin"
        fish_add_path $XDG_CACHE_HOME/.bun/bin
    end

    if test -d "$XDG_DATA_HOME/SDK/flutter/bin"
        fish_add_path $XDG_DATA_HOME/SDK/flutter/bin
    end
end
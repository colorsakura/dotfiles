# --------------------------
# macOS-specific Configuration
# --------------------------
# This file contains macOS-specific configurations that mirror the Linux setup

# Use XDG directories (defined in main config.fish)
# XDG_CACHE_HOME, XDG_CONFIG_HOME, XDG_DATA_HOME, XDG_STATE_HOME

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
    # Use standard GOPROXY for macOS
    set -x GOPROXY "https://proxy.golang.org,direct"
    fish_add_path $GOPATH/bin
    echo "Go environment configured: GOPATH=$GOPATH"
else
    echo "Go not found, skipping Go environment setup"
end

# Rust
if type -q rustc
    set -x CARGO_HOME "$XDG_DATA_HOME/cargo"
    set -x RUSTUP_HOME "$XDG_DATA_HOME/rustup"
    echo "Rust environment configured: CARGO_HOME=$CARGO_HOME"
else
    echo "Rust not found, skipping Rust environment setup"
end

# Python
set -x IPYTHONDIR "$XDG_CONFIG_HOME/jupyter"
set -x JUPYTER_CONFIG_DIR "$XDG_CONFIG_HOME/jupyter"

# Ruby
set -x BUNDLE_PATH $XDG_DATA_HOME/bundle

# Java (macOS specific)
if type -q java
    # Set JAVA_HOME if not already set
    if not set -q JAVA_HOME
        set -x JAVA_HOME (/usr/libexec/java_home 2>/dev/null)
        if set -q JAVA_HOME
            echo "Java home configured: $JAVA_HOME"
        else
            echo "Could not determine JAVA_HOME"
        end
    end
end

# --------------------------
# macOS-specific Environment Variables
# --------------------------
# Set default shell to use user's preferred shell
set -x SHELL (which fish)

# macOS-specific path additions
fish_add_path /opt/homebrew/bin  # Homebrew on Apple Silicon
fish_add_path /usr/local/bin     # Homebrew on Intel
fish_add_path /opt/local/bin     # MacPorts

# --------------------------
# macOS-specific Applications
# --------------------------
# Set default applications for macOS
set -x BROWSER open
set -x PAGER less

# --------------------------
# macOS-specific Aliases
# --------------------------
# macOS-specific ls options
if type -q gls  # GNU ls from coreutils
    alias ls gls
    alias la "gls -A"
    alias ll "gls -al"
else
    alias ls "ls -G"  # Use -G for color on macOS
    alias la "ls -GA"
    alias ll "ls -Gal"
end

# macOS-specific aliases
alias o open
alias finder 'open .'
alias pb 'pbcopy'
alias pbp 'pbpaste'

# --------------------------
# macOS-specific Input Method
# --------------------------
# For macOS, we typically don't need to set input method environment variables
# as they are handled by the system, but we can set them if needed
if test -n "$XDG_SESSION_TYPE"
    # If running under X11 on macOS
    if test "$XDG_SESSION_TYPE" = "x11"
        set -x GTK_IM_MODULE fcitx
        set -x QT_IM_MODULE fcitx
        set -x XMODIFIERS @im=fcitx
    end
end

# --------------------------
# macOS-specific Tools Integration
# --------------------------
# Homebrew services management
if type -q brew
    alias bs "brew services"
    alias bsl "brew services list"
    alias bsst "brew services start"
    alias bsps "brew services stop"
    alias bsrest "brew services restart"
end

# --------------------------
# Jetbrains APPS Configuration
# --------------------------
set -l jetbrains_config "$HOME/.jetbrains.vmoptions.sh"
if test -e "$jetbrains_config"
    source "$jetbrains_config"
    echo "JetBrains configuration loaded from $jetbrains_config"
end

# Interactive Session Configuration
if status is-interactive
    echo "Loading macOS interactive session configuration..."

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
    
    # Add bun path if it exists
    if test -d "$XDG_CACHE_HOME/.bun/bin"
        fish_add_path $XDG_CACHE_HOME/.bun/bin
    end

    # --------------------------
    # Shell Enhancement Tools
    # --------------------------
    # Starship prompt
    if type -q starship
        starship init fish | source
        echo "Starship prompt initialized"
    else
        echo "Starship not found, skipping prompt customization"
    end

    # Zoxide smart cd
    if type -q zoxide
        zoxide init fish | source
        echo "Zoxide initialized"
    else
        echo "Zoxide not found, skipping smart cd setup"
    end

    # Fuzzy finder
    if type -q fzf
        fzf --fish | source
        set -x FZF_DEFAULT_COMMAND 'fd --type file'
        set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
        echo "FZF initialized with fd as default command"
    else
        echo "FZF not found, skipping fuzzy finder setup"
    end

    # Shell history enhancement
    if type -q atuin
        atuin init fish --disable-up-arrow | source
        echo "Atuin initialized for enhanced history"
    else
        echo "Atuin not found, skipping history enhancement"
    end

    # Environment management
    if type -q direnv
        direnv hook fish | source
        echo "Direnv hook initialized"
    else
        echo "Direnv not found, skipping environment management setup"
    end
end
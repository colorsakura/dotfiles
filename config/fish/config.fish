# Fish config

# From https://github.com/trapd00r/LS_COLORS
source ~/.config/fish/lscolors.csh

set -U fish_emoji_width 2

set -gx EDITOR (which nvim)
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR
set -gx GPG_TTY (tty)

# Path
set -Ux fish_user_paths

set -x XDG_CACHE_HOME $HOME/.cache
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_STATE_HOME $HOME/.local/state

set -x GOPATH "$XDG_DATA_HOME"/go
set -x CARGO_HOME "$XDG_DATA_HOME"/cargo
set -x RUSTUP_HOME "$XDG_DATA_HOME"/rustup
set -x IPYTHONDIR "$XDG_CONFIG_HOME"/jupyter
set -x JUPYTER_CONFIG_DIR "$XDG_CONFIG_HOME"/jupyter

[ -d "$XDG_DATA_HOME"/gnupg ] || mkdir -m 700 -p "$XDG_DATA_HOME/gnupg"
set -x GNUPGHOME "$XDG_DATA_HOME"/gnupg

fish_add_path $GOPATH/bin
fish_add_path $CARGO_HOME/bin
fish_add_path $HOME/.local/bin
fish_add_path $XDG_CONFIG_HOME/rofi/scripts

set -x PYTHONPATH ~/.local/lib/python3.11/site-packages
set -x PYTHONPATH /usr/lib/python3.11/site-packages $PYTHONPATH

# Fcitx5
set -x GLFW_IM_MODULE fcitx
set -x GTK_IM_MODULE fcitx
set -x INPUT_METHOD fcitx
set -x QT_IM_MODULE fcitx
set -x SDL_IM_MODULE fcitx
set -x XMODIFIERS @im=fcitx

# Wayland
set -x ANKI_WAYLAND 1            # Anki wayland
set -x CLUTTER_BACKEND wayland
set -x MOZ_ENABLE_WAYLAND 1      # Firefox wayland
set -x QT_QPA_PLATFORM wayland
set -x SDL_VIDEODRIVER wayland
set -x WINIT_UNIX_BACKEND wayland
set -x XDG_SESSION_TYPE wayland

# ISSUE: fix miss cuda for mpv
# https://wiki.archlinux.org/title/Hardware_video_acceleration#Configuring_VA-API
set -x LIBVA_DRIVER_NAME iHD
set -x VDPAU_DRIVER va_gl

# rustup bootstrap
set -x RUSTUP_UPDATE_ROOT https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
set -x RUSTUP_DIST_SERVER https://mirrors.tuna.tsinghua.edu.cn/rustup

set -x LIBVIRT_DEFAULT_URI "qemu:///system"
# set -x GNOME_DESKTOP_SESSION_ID 0
# set -x LC_CTYPE zh_CN.UTF-8
set -x LC_CTYPE en_US.UTF-8

set -x WOBSOCK $XDG_RUNTIME_DIR/wob.sock
# set -x CLION_VM_OPTIONS $HOME/dotfiles/utils/scripts/jetbra/vmoptions/clion.vmoptions

# Alias
alias c="curl"
alias g="git"
alias ga="git add"
alias gc="git commit"
alias gs="git status"
alias h="tldr"
alias sudo='sudo -E '
alias tree="tree -a -I .git --dirsfirst"
alias v="nvim"

# 切记在设置环境变量后运行
if status --is-login
   if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
      set WLR_RENDERER vulkan
      set -x XDG_CURRENT_DESKTOP sway
      exec sway &> /tmp/startx.log || true
   end
   if test -z "$DISPLAY" -a "$XDG_VTNR" = 2
      set -x XDG_SESSION_DESKTOP hyprland
      exec Hyprland > /tmp/startx.log || true
   end
end

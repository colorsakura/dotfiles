# fish config

set -U fish_theme tokyonight_night

set -gx EDITOR (which nvim)
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR
set -gx GPG_TTY (tty)

# Path
set -Ux fish_user_paths
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin
fish_add_path ~/.config/rofi/scripts

set -x PYTHONPATH ~/.local/lib/python3.11/site-packages
set -x PYTHONPATH /usr/lib/python3.11/site-packages $PYTHONPATH

# Fish
set -U fish_emoji_width 2

# Fcitx5
set -x GTK_IM_MODULE fcitx
set -x QT_IM_MODULE fcitx
set -x XMODIFIERS @im=fcitx
set -x INPUT_METHOD fcitx
set -x GLFW_IM_MODULE fcitx

# Wayland
set -x QT_QPA_PLATFORM wayland
set -x CLUTTER_BACKEND wayland
set -x SDL_VIDEODRIVER wayland
set -x MOZ_ENABLE_WAYLAND 1

set -x XDG_SESSION_TYPE wayland
# set -x XDG_SESSION_DESKTOP hyprland
# set -x XDG_CURRENT_DESKTOP hyprland

set -x ANKI_WAYLAND 1

set -x WINIT_UNIX_BACKEND wayland

# set -x WLR_RENDERER vulkan
set -x LIBVIRT_DEFAULT_URI "qemu:///system"
set -x GNOME_DESKTOP_SESSION_ID 0
# set -x LC_CTYPE zh_CN.UTF-8
set -x LC_CTYPE en_US.UTF-8

set -x WOBSOCK $XDG_RUNTIME_DIR/wob.sock
set -x GTK_THEME WhiteSur-Dark
set -x XCURSOR_THEME WhiteSur-cursors
set -x CLION_VM_OPTIONS $HOME/dotfiles/utils/scripts/jetbra/vmoptions/clion.vmoptions

#
# Alias
alias v="nvim"
alias c="curl"
alias h="tldr"
alias g="git"
alias ga="git add"
alias gc="git commit"
alias gs="git status"

# 切记在设置环境变量后运行
if status --is-login
   if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
      # exec Hyprland
      set WLR_RENDERER vulkan
      exec sway
   end
end

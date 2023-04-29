# fish config

set -gx EDITOR (which nvim)
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR
set -gx GPG_TTY (tty)
set -gx PROMPT_COMMAND (history merge)

# Path
set -Ux fish_user_paths
fish_add_path ~/.scripts
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin

# Fish
set -U fish_emoji_width 2

# Fcitx5
set -x GTK_IM_MODULE fcitx
set -x QT_IM_MODULE fcitx
set -x XMODIFIERS @im=fcitx
set -x INPUT_METHOD fcitx
set -x GLFW_IM_MODULE fcitx

set -x QT_QPA_PLATFORM wayland
set -x CLUTTER_BACKEND wayland
set -x SDL_VIDEODRIVER wayland
set -x MOZ_ENABLE_WAYLAND 1

set -x XDG_SESSION_TYPE wayland
set -x XDG_SESSION_DESKTOP hyprland
set -x XDG_CURRENT_DESKTOP hyprland

# set -x WLR_RENDERER vulkan
set -x LIBVIRT_DEFAULT_URI "qemu:///system"
set -x GNOME_DESKTOP_SESSION_ID 0
set -x LC_CTYPE zh_CN.UTF-8

## Anki
set -x ANKI_WAYLAND 1

# XWAYLAND
# 使用wint的rust应用，wayland下不支持输入法 x11/wayland
set -x WINIT_UNIX_BACKEND wayland
# set -x GDK_SCALE 2

# Atuin
atuin init fish | source

# 切记在设置环境变量后运行
#if status --is-login
#    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
#        exec wayfire -d > ~/.wayfire.log
#    end
#end

function update --description 'Update fish, tld, rust and etc'

    # update fish completion cache
    and echo "[update] fish"
    and fish_update_completions > /dev/null

    # tldr
    # update tldr local cache
    and echo "[update] tldr"
    and command tldr -u > /dev/null

    # rustup update
    and echo "[update] rust"
    and command rustup update > /dev/null

    # tmux plugins
    and echo "[update] tmux plugins"
    and bash ~/.local/state/tmux/plugins/tpm/bin/install_plugins > /dev/null

    # update font cache
    and echo "[update] font cache"
    and command fc-cache -fvr > /dev/null

    # update firefox-ui-fix
    and echo "[update] firefox-ui-fix"
    and command echo 4 | bash -c "$(curl -fsSL https://raw.githubusercontent.com/black7375/Firefox-UI-Fix/master/install.sh)" > /dev/null

end
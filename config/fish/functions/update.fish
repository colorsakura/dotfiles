function update --description 'Update fish, tld, rust and etc'

    # update fish completion cache
    and echo "[update] fish"
    and fish_update_completions

    # tldr
    # update tldr local cache
    and echo "[update] tldr"
    and command tldr -u

    # rustup update
    and echo "[update] rust"
    and command rustup update

    # tmux plugins
    and echo "[update] tmux plugins"
    and bash ~/.local/state/tmux/plugins/tpm/bin/install_plugins

    # update font cache
    and echo "[update] font cache"
    and command fc-cache -fvr

end

function update --description 'Update fish, tld, rust and etc'

    # update fish completion cache
    and echo "[update] fish"
    and fish_update_completions

    # tldr
    and echo "[update] tldr"
    and command tldr -u

    # rustup update
    and echo "[update] rust"
    and command rustup update

end

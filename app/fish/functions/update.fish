function update --description 'Update fish, tld, rust and etc'
    set -l success_count 0
    set -l total_updates 6

    # Update fish completion cache
    if type -q fish_update_completions
        echo "[update] fish completions..."
        if fish_update_completions > /dev/null 2>&1
            echo "[success] fish completions updated"
            set -l success_count (math $success_count + 1)
        else
            echo "[error] failed to update fish completions"
        end
    else
        echo "[skip] fish_update_completions not available"
    end

    # Update tldr local cache
    if type -q tldr
        echo "[update] tldr cache..."
        if command tldr -u > /dev/null 2>&1
            echo "[success] tldr cache updated"
            set -l success_count (math $success_count + 1)
        else
            echo "[error] failed to update tldr cache"
        end
    else
        echo "[skip] tldr not available"
    end

    # Update rust
    if type -q rustup
        echo "[update] rust..."
        if command rustup update > /dev/null 2>&1
            echo "[success] rust updated"
            set -l success_count (math $success_count + 1)
        else
            echo "[error] failed to update rust"
        end
    else
        echo "[skip] rustup not available"
    end

    # Update tmux plugins
    set -l tmux_plugin_dir "$HOME/.local/state/tmux/plugins/tpm"
    if test -d "$tmux_plugin_dir" && test -f "$tmux_plugin_dir/bin/install_plugins"
        echo "[update] tmux plugins..."
        if bash "$tmux_plugin_dir/bin/install_plugins" > /dev/null 2>&1
            echo "[success] tmux plugins updated"
            set -l success_count (math $success_count + 1)
        else
            echo "[error] failed to update tmux plugins"
        end
    else
        echo "[skip] tmux plugin manager not found at $tmux_plugin_dir"
    end

    # Update font cache
    if type -q fc-cache
        echo "[update] font cache..."
        if command fc-cache -fvr > /dev/null 2>&1
            echo "[success] font cache updated"
            set -l success_count (math $success_count + 1)
        else
            echo "[error] failed to update font cache"
        end
    else
        echo "[skip] fc-cache not available"
    end

    # Update firefox-ui-fix
    echo "[update] firefox-ui-fix..."
    if command curl -fsSL https://raw.githubusercontent.com/black7375/Firefox-UI-Fix/master/install.sh | bash -c 'echo 4 | bash -s -' > /dev/null 2>&1
        echo "[success] firefox-ui-fix updated"
        set -l success_count (math $success_count + 1)
    else
        echo "[error] failed to update firefox-ui-fix"
    end

    # Summary
    echo "Updates completed: $success_count/$total_updates successful"
end
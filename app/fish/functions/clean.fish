function clean --argument-names "subcommand" --description 'Clean various cache and data directories'
    switch $subcommand
        case "nvim"
            echo "Cleaning Neovim cache and data directories..."

            # Define nvim directories to clean
            set -l nvim_dirs "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"

            set -l cleaned_count 0
            for dir in $nvim_dirs
                if test -d "$dir"
                    if command rm -rf "$dir"
                        echo "Removed: $dir"
                        set -l cleaned_count (math $cleaned_count + 1)
                    else
                        echo "Error: Failed to remove $dir"
                    end
                else
                    echo "Skipped (not found): $dir"
                end
            end

            echo "Cleaned $cleaned_count Neovim directories"

        case "all"
            echo "This would clean all possible caches (not implemented yet)"
            # Future implementation could add more cleaning options

        case "*"
            echo "Usage: clean [nvim|all]"
            echo "Available subcommands:"
            echo "  nvim - Clean Neovim cache and data directories"
            echo "  all  - Clean all possible caches (not yet implemented)"
            return 1
    end
end
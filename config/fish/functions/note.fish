function note --description "Open Obsidian Notes"
    # Configuration
    set -l note_dir "$HOME/Onedrive/Documents/Obsidian"

    # Check if required tools are available
    if not type -q nvim
        echo "Error: nvim not found"
        return 1
    end

    # Ensure note directory exists
    if not test -d "$note_dir"
        echo "Error: Notes directory does not exist: $note_dir"
        return 1
    end

    # Change to notes directory and open nvim
    cd "$note_dir"
    nvim
end
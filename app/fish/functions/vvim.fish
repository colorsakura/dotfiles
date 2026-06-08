function vvim --description 'Choose and use alternative Neovim configuration'
    # Configuration
    set -l config_dir "$HOME/.config"
    set -l nvim_config_pattern "nvim-*"

    # Check if required tools are available
    if not type -q nvim
        echo "Error: nvim not found"
        return 1
    end

    if not type -q fd
        echo "Error: fd not found"
        return 1
    end

    if not type -q fzf
        echo "Error: fzf not found"
        return 1
    end

    # Ensure config directory exists
    if not test -d "$config_dir"
        echo "Error: Config directory does not exist: $config_dir"
        return 1
    end

    # Find available Neovim configurations
    set -l configs (fd --max-depth 1 --glob "$nvim_config_pattern" "$config_dir" | head -20)  # Limit to 20 configs

    # Check if any configs were found
    if test -z "$configs"
        echo "No Neovim configurations found matching pattern: $nvim_config_pattern"
        return 1
    end

    # Select configuration with fzf
    set -l config (printf '%s\n' $configs | fzf --prompt="Select Neovim Config > " --height=~50% --layout=reverse --border --exit-0)

    if test -z "$config"
        echo "No configuration selected"
        return 1
    end

    # Validate that the selected config exists and is a directory
    if not test -d "$config"
        echo "Error: Selected configuration does not exist or is not a directory: $config"
        return 1
    end

    # Set the NVIM_APPNAME environment variable and start nvim
    set -x NVIM_APPNAME (basename "$config")
    echo "Using Neovim configuration: $NVIM_APPNAME"
    nvim $argv
end
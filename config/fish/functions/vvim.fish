function vvim --description 'Choose your nvim config'
  set config (fd --max-depth 1 --glob 'nvim-*' ~/.config | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)
  if test -z "$config"
    echo "No config selected"
    return
  end

  set -x NVIM_APPNAME (basename $config)
  nvim $argv
end
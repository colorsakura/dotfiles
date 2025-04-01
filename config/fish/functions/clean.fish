function clean --argument-names "subcommand" --description 'Clean some files'
  if test $subcommand = "nvim"
    echo "clean nvim"
    command rm ~/.local/share/nvim -rf
    command rm ~/.local/state/nvim -rf
    command rm ~/.cache/nvim -rf
  end
end
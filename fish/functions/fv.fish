function fv
  cd ( du -a ~/ | awk '{print $2}' | fzf ); nvim
end

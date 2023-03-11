function update --description 'Update packages, fish, tld'
  ~

  # tldr
  # and echo "[update] tldr"
  # and command tldr -u

  # update fish completion cache
  and echo "[update] fish"
  and fish_update_completions

end

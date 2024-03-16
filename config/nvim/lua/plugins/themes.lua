local function is_neovide()
  if vim.g.neovide then
    return true
  else
    return false
  end
end

return {
  {
    "tokyonight.nvim",
    opts = {
      transparent = not is_neovide(),
    },
  },
}

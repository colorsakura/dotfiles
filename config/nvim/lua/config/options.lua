-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

if vim.g.neovide then
  vim.o.guifont = "monospace:h13"

  vim.g.neovide_transparency = 0.90
  vim.g.neovide_window_blurred = true
  vim.g.neovide_theme = "auto"
end

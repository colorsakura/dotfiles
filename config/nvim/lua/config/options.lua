-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.root_spec = { "lsp", { ".git", ".github", "lua" }, "cwd" }
-- Disable LazyVim auto format
vim.g.autoformat = false
-- 避免重绘所有行
vim.opt.relativenumber = false
vim.opt.synmaxcol = 500

-- neovide setup
if vim.g.neovide then
  vim.o.guifont = "monospace:h13"

  vim.g.neovide_theme = "auto"
end

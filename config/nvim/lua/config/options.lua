-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Enable LazyVim auto format
vim.g.autoformat = false
-- 绘制宽度限制线
vim.opt.colorcolumn = "120"
-- Disable mouse
vim.opt.mouse = ""

-- Neovide
if vim.g.neovide then
  vim.o.guifont = "monospace:h11"
end

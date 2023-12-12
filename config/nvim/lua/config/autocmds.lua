-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local autocmd = vim.api.nvim_create_autocmd

-- 仅插入模式使用粘贴模式
autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

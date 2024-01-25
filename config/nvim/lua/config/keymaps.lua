-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap

keymap.set({ "n", "t" }, "<A-1>", "<cmd>Neotree toggle<CR>", { desc = "Neotree" })
keymap.set({ "n" }, "<Tab>", "<cmd>bn<CR>", { desc = "Next buffer" })
keymap.set({ "n" }, "<S-Tab>", "<cmd>bp<CR>", { desc = "Prev buffer" })

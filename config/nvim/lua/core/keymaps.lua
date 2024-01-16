local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- better up/down
keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Move Lines
keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Clear search with <esc>
keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- better indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

--- Neotree
keymap.set({ "n", "t" }, "<A-1>", "<cmd>Neotree last toggle<CR>", { desc = "Neotree toggle" })

--- Terminal
local Terminal = require("toggleterm.terminal").Terminal:new()
function _terminal_toggle()
	Terminal:toggle()
end
keymap.set({ "n", "t" }, "<A-2>", "<cmd>lua _terminal_toggle()<CR>", {desc="Open terminal"})

--- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

--- Code formater
keymap.set({ "n", "v" }, "<A-S-I>", "<cmd>GuardFmt<CR>")

--- Lsp and lspsaga
-- keymap.set("n", "ga", "<cmd>Lspsaga code_action<CR>")
-- keymap.set("n", "gD", "<cmd>Lspsaga peek_definition<CR>")
-- keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>")
-- keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>")
-- keymap.set("n", "gi", "<cmd>Lspsaga finder imp<CR>")
-- keymap.set({ "n", "t" }, "<A-2>", "<cmd>Lspsaga term_toggle<CR>", { desc = "Lspsaga float terminal" })
-- keymap.set("n", "<leader>cr", "<cmd>Lspsaga rename<CR>", { desc = "Lspsaga rename" })

--- Buffer
keymap.set("n", "<Tab>", "<cmd>bn<CR>")

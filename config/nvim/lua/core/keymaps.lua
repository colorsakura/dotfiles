local map = vim.keymap.set

-- TODO: some plugins need to set keybmap

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map({ "n", "t" }, "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map({ "n", "t" }, "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map({ "n", "t" }, "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map({ "n", "t" }, "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Split window
map("n", "ss", "<cmd>split<CR>", {})
map("n", "sv", "<cmd>vsplit<CR>", {})
map("n", "sq", "<C-w>c", { desc = "Close the window" })

-- Buffer
map("n", "sc", "<cmd>BufferClose<CR>", { desc = "Close the buffer" })
map("n", "<Tab>", "<cmd>BufferNext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>BufferPrevious<CR>", { desc = "Prev buffer" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Terminal
map({ "n", "t" }, "<C-`>", "<cmd>ToggleTerm<CR>", { desc = "Open the terminal" })

-- Telescope
local builtin = require("telescope.builtin")
map("n", "<C-p>", builtin.find_files, { desc = "Find files" })

map("n", "<C-s>", "<cmd>write<CR>", { desc = "Save" })

-- Neotree
map({ "n", "t" }, "<C-n>", "<cmd>Neotree toggle<CR>", { desc = "Open Neotree" })

-- Lsp
map('n', 'gD', vim.lsp.buf.declaration, {})
map('n', 'gd', vim.lsp.buf.definition, {})
map('n', 'K', vim.lsp.buf.hover, {})
map('n', 'gi', vim.lsp.buf.implementation, {})
-- map('n', '<C-k>', vim.lsp.buf.signature_help, {})
map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, {})
map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, {})
map('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, {})
map('n', '<leader>D', vim.lsp.buf.type_definition, {})
map('n', 'gcr', vim.lsp.buf.rename, {})
map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
map('n', 'gr', vim.lsp.buf.references, {})
map('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, {})

-- Comments

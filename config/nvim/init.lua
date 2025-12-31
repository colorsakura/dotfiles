if vim.loader then vim.loader.enable() end

-- {{{ Options
-- Leader key
vim.g.mapleader = vim.keycode "<space>"
vim.g.maplocalleader = "\\"

-- Disable providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

vim.g.editorconfig = false

-- UI
vim.g.winborder = "none"

-- Global
vim.g.ai = "supermaven"

vim.opt.autowrite = true  -- Enable auto write
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.conceallevel = 2  -- Hide * markup for bold and italic, but not markers with substitutions
vim.opt.confirm = true    -- Confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.expandtab = true  -- Use spaces instead of tabs
vim.opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
vim.opt.foldlevel = 0              -- 控制打开折叠的深度
vim.opt.foldcolumn = "auto"        -- 显示图标
vim.opt.formatoptions = "jcroqlnt" -- tcqj
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.ignorecase = true      -- Ignore case
vim.opt.inccommand = "nosplit" -- preview incremental substitute
vim.opt.jumpoptions = "view"
vim.opt.laststatus = 0         -- statusline
vim.opt.linebreak = true       -- Wrap lines at convenient points
vim.opt.list = true            -- Show some invisible characters (tabs...
vim.opt.mouse = ""             -- "a" -- Enable mouse mode
vim.opt.number = true          -- Print line number
vim.opt.pumblend = 10          -- Popup blend
vim.opt.pumheight = 10         -- Maximum number of entries in a popup
vim.opt.ruler = false          -- Disable the default ruler
vim.opt.scrolloff = 4          -- Lines of context
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
vim.opt.shiftround = true      -- Round indent
vim.opt.shiftwidth = 2         -- Size of an indent
vim.opt.shortmess:append { W = true, I = true, c = true, C = true }
vim.opt.showmode = true        -- Dont show mode since we have a statusline
vim.opt.sidescrolloff = 8      -- Columns of context
vim.opt.signcolumn =
"yes"                          -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.smartcase = true       -- Don't ignore case with capitals
vim.opt.smartindent = true     -- Insert indents automatically
vim.opt.splitbelow = true      -- Put new windows below current
vim.opt.splitkeep = "screen"
vim.opt.spelllang = { "en" }   -- Default spell language
vim.opt.splitright = true      -- Put new windows right of current
vim.opt.tabstop = 2            -- Number of spaces tabs count for
vim.opt.termguicolors = true   -- True color support
vim.opt.timeoutlen = vim.g.vscode and 1000 or
		500                        -- Lower than default (1000) to quickly trigger which-key, if no which-key, set to 500
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200               -- Save swap file and trigger CursorHold
vim.opt.virtualedit = "block"          -- Allow cursor to move where there is no text in visual block mode
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.winminwidth = 5                -- Minimum window width
vim.opt.modelines = 1                  -- only check two lines for modeline
vim.opt.wrap = false                   -- Disable line wrap
vim.opt.fileencodings = "ucs-bom,utf-8,gbk,gb18030,gb2312,cp936,latin1"
vim.opt.fileformats = "unix,dos,mac"

vim.schedule(function()
	-- only set clipboard if not in ssh, to make sure the OSC 52
	-- integration works automatically. Requires Neovim >= 0.10.0
	vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
end)

if vim.fn.has "nvim-0.10" == 1 then
	vim.opt.smoothscroll = true
	vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	vim.opt.foldmethod = "expr"
	vim.opt.foldtext = ""
else
	vim.opt.foldmethod = "indent"
end

if vim.g.neovide then
	if vim.fn.has "linux" == 1 then vim.opt.guifont = "JetBrains Mono,monospace:h13" end
	if vim.fn.has "win32" == 1 then vim.opt.guifont = "JetBrains Mono NF,monospace:h13" end
	vim.opt.linespace = 0
end
-- }}}

-- {{{ Plugins
vim.pack.add({
	{
		src = "git@github.com:nvim-treesitter/nvim-treesitter",
		version = "main",
	},
	{
		src = "git@github.com:catppuccin/nvim",
		name = "catppuccin",
		version = vim.version.range "1.*",
	},
	{
		src = "git@github.com:neovim/nvim-lspconfig",
	},
}, {})

vim.pack.add({
	{
		src = "git@github.com:saghen/blink.cmp",
		version = vim.version.range "1.*",
	},
	{
		src = "git@github.com:folke/snacks.nvim",
		version = vim.version.range "*",
	},
	{
		src = "git@github.com:stevearc/oil.nvim",
		version = vim.version.range "*",
	} }, {
})

-- TODO: blink.pairs is broken now
vim.pack.add(
	{ {
		src = "git@github.com:saghen/blink.pairs",
		version = vim.version.range "0.*",
	},
		{
			src = "git@github.com:saghen/blink.download",
		}, },
	{
	})

vim.cmd "colorscheme catppuccin"

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
	once = true,
	callback = function()
		require("blink.cmp").setup()
	end
})

require("oil").setup()

-- }}}

-- {{{ Keymaps
local map = vim.keymap.set

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Move cursor in insert mode using the <alt> hjkl keys
map("i", "<A-h>", "<Left>", { desc = "Left", remap = true })
map("i", "<A-j>", "<Down>", { desc = "Down", remap = true })
map("i", "<A-k>", "<Up>", { desc = "Up", remap = true })
map("i", "<A-l>", "<Right>", { desc = "Right", remap = true })

-- buffers
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- terminal
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- Clear search and stop snippet on escape
map({ "i", "n", "s" }, "<esc>", function()
	vim.cmd "noh"
	if vim.snippet then vim.snippet.stop() end
	return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
	"n",
	"<leader>ur",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- FIXME:
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- TODO:
-- diagnostic
local diagnostic_goto = function(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function() go { severity = severity } end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- windows
map("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>w\\", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- tabs
map("n", "<leader>tl", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader>tf", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader>t]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader>td", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader>t[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- lsp
vim.api.nvim_create_autocmd({ "LspAttach" }, {
	callback = function(e)
		local client = vim.lsp.get_client_by_id(e.data.client_id)
		if not client then return end

		-- auto enable neovim lsp features
		if client:supports_method "textDocument/inlayHint" then vim.lsp.inlay_hint.enable() end
		if client:supports_method "textDocument/foldingRange" then
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		end
		if client:supports_method "textDocument/codeLens" then
			vim.lsp.codelens.refresh()
			vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
				buffer = buffer,
				callback = vim.lsp.codelens.refresh,
			})
		end

		-- keymaps
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = e.buf, desc = "Hover" })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = e.buf, desc = "Goto Definition" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = e.buf, desc = "Goto Declaration" })
		vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { buffer = e.buf, desc = "Goto TypeDefinition" })
		vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { buffer = e.buf, desc = "Goto Implementation" })
		vim.keymap.set("n", "grr", vim.lsp.buf.references, { buffer = e.buf, desc = "Goto References" })
		vim.keymap.set("n", "grs", vim.lsp.buf.signature_help, { buffer = e.buf, desc = "Signature Help" })
		vim.keymap.set("n", "grn", vim.lsp.buf.rename, { buffer = e.buf, desc = "Code Rename" })
		vim.keymap.set("n", "gra", vim.lsp.buf.code_action, { buffer = e.buf, desc = "Code Action" })
		vim.keymap.set("n", "gri", vim.lsp.buf.implementation, { buffer = e.buf, desc = "Goto Implementation" })
		vim.keymap.set(
			{ "n", "x" },
			"grf",
			-- TODO:
			-- function() require("conform").format() end,
			vim.lsp.buf.format,
			{ buffer = e.buf, desc = "Code Format" }
		)
		vim.keymap.set(
			"n",
			"grd",
			function() require("goto-preview").goto_preview_definition() end,
			{ buffer = e.buf, desc = "Goto Definition" }
		)
		vim.keymap.set(
			"n",
			"grt",
			function() require("goto-preview").goto_preview_type_definition() end,
			{ buffer = e.buf, desc = "Goto Type Definition" }
		)
		vim.keymap.set(
			"n",
			"grD",
			function() vim.lsp.buf.declaration() end,
			{ buffer = e.buf, desc = "Goto Declaration" }
		)
	end,
})
-- }}}

-- {{{ Autocmds
-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function() (vim.hl or vim.highlight).on_yank() end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = vim.api.nvim_create_augroup("checktime", { clear = true }),
	callback = function()
		if vim.o.buftype ~= "nofile" then vim.cmd "checktime" end
	end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
	pattern = {
		"checkhealth",
		"dbout",
		"gitsigns-blame",
		"grug-far",
		"help",
		"lspinfo",
		"neotest-output",
		"neotest-output-panel",
		"neotest-summary",
		"notify",
		"oil",
		"PlenaryTestPopup",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", {
			buffer = event.buf,
			silent = true,
			desc = "Quit buffer with <q>",
		})
	end,
})

-- Quit Neovim if more than one window is open and only sidebar windows are list
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("quit_only_sidebars", { clear = true }),
	callback = function()
		local wins = vim.api.nvim_tabpage_list_wins(0)
		-- Both neo-tree and aerial will auto-quit if there is only a single window left
		if #wins <= 1 then return end
		local sidebar_fts = { aerial = true, ["neo-tree"] = true }
		for _, winid in ipairs(wins) do
			if vim.api.nvim_win_is_valid(winid) then
				local bufnr = vim.api.nvim_win_get_buf(winid)
				local filetype = vim.bo[bufnr].filetype
				-- If any visible windows are not sidebars, early return
				if not sidebar_fts[filetype] then
					return
					-- If the visible window is a sidebar
				else
					-- only count filetypes once, so remove a found sidebar from the detection
					sidebar_fts[filetype] = nil
				end
			end
		end
		if #vim.api.nvim_list_tabpages() > 1 then
			vim.cmd.tabclose()
		else
			vim.cmd.qall()
		end
	end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = vim.api.nvim_create_augroup("resize_splits", { clear = true }),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd "tabdo wincmd ="
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = vim.api.nvim_create_augroup("last_loc", { clear = true }),
	callback = function(ev)
		local exclude = { "gitcommit" }
		local buf = ev.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc_restored then return end
		vim.b[buf].last_loc_restored = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
	end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("man_unlisted", { clear = true }),
	pattern = { "man" },
	callback = function(event) vim.bo[event.buf].buflisted = false end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("wrap_spell", { clear = true }),
	pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
	callback = function() vim.opt_local.wrap = true end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
	callback = function(ev)
		if ev.match:match "^%w%w+:[\\/][\\/]" then return end
		local file = vim.uv.fs_realpath(ev.match) or ev.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- }}}

-- {{{ Lsp
vim.lsp.enable({ "lua_ls", "qmlls", "dartls", "clangd", "zig", "rust_analyzer", "gopls", "ruff" })
-- }}}
-- vim: set ts=2 fdm=marker noexpandtab:

vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus" -- connection to the system clipboard
vim.opt.cmdheight = 0             -- cmdheight disable
vim.opt.colorcolumn = "80"        -- draw a line at 120 columns
vim.opt.copyindent = true         -- copy the previous indentation on autoindenting
vim.opt.cursorline = true
vim.opt.fileencoding = "utf-8"
vim.opt.laststatus = 3    -- global statusline
vim.opt.number = true     -- show numbers line
vim.opt.pumheight = 10    -- height of the pop up menu
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true -- splitting a new window below the current one
vim.opt.splitright = true -- splitting a new window at the right of the current one
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.undofile = true
vim.opt.termguicolors = true  -- enable 24-bit RGB color in the TUI
vim.opt.virtualedit = "block" -- allow going past end of line in visual block mode
vim.opt.wrap = false          -- disable wrapping of lines longer than the width of window
vim.opt.writebackup = false   -- disable making a backup before overwriting a file
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.timeoutlen = 500
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.synmaxcol = 200 -- loog line make slower
vim.opt.fillchars = {
	foldopen = "",
	foldclose = "",
	-- fold = "⸱",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

if vim.fn.has("nvim-0.10") == 1 then
	vim.opt.smoothscroll = true
end

-- HACK: causes freezes on <= 0.9, so only enable on >= 0.10 for now
if vim.fn.has("nvim-0.10") == 1 then
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
else
	vim.opt.foldmethod = "indent"
end

-- Neovide options
if vim.g.neovide then
	vim.opt.guifont = "monospace:h13"
end

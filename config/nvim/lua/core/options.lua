vim.opt.viewoptions:remove "curdir"             -- disable saving current directory with views
vim.opt.shortmess:append { s = true, I = true } -- disable search count wrap and startup messages
vim.opt.backspace:append { "nostop" }           -- don't stop backspace at insert
if vim.fn.has "nvim-0.9" == 1 then
	vim.opt.diffopt:append "linematch:60"   -- enable linematch diff algorithm
end

vim.g.mapleader = " "
vim.o.number = true  -- show numbers line
vim.o.laststatus = 3 -- global statusline
vim.o.tabstop = 2
vim.o.signcolumn = "yes"
vim.o.clipboard = "unnamedplus" -- connection to the system clipboard
vim.o.fileencoding = "utf-8"
vim.o.cursorline = true
-- vim.o.fillchars = { eob = " " } -- disable `~` on nonexistent lines
vim.o.pumheight = 10        -- height of the pop up menu
vim.o.termguicolors = true  -- enable 24-bit RGB color in the TUI
vim.o.virtualedit = "block" -- allow going past end of line in visual block mode
vim.o.wrap = false          -- disable wrapping of lines longer than the width of window
vim.o.writebackup = false   -- disable making a backup before overwriting a file
vim.o.cmdheight = 0         -- cmdheight disable

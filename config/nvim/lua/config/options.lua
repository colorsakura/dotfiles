-- Editing
vim.opt.number = true
vim.opt.cursorline = true

vim.opt.showbreak = "↳"
vim.opt.whichwrap = "h,l,<,>"

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true

-- Indent
vim.opt.smartindent = true

-- UI
vim.opt.pumheight = 10
vim.opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.laststatus = 3

vim.opt.ruler = false
vim.opt.colorcolumn = "120"
vim.opt.signcolumn = "yes"

vim.opt.scrolloff = 5

-- NOTE: 启用鼠标会增强中文输入的使用体验
-- vim.opt.mouse = "" -- disable mouse

vim.g.border = "rounded"

-- Cache/Log file
vim.opt.swapfile = false
vim.opt.undofile = true

vim.lsp.set_log_level "OFF"

-- Rendering
vim.opt.termguicolors = true

-- Misc
vim.opt.history = 1000
vim.opt.wildignorecase = true

vim.opt.ttimeoutlen = 10

vim.opt.titlestring = "%m %f (%{mode()}) | nvim"

-- vim: set ts=2 noexpandtab:

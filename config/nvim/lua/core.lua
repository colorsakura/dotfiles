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

-- Folding
if vim.fn.has "nvim-0.10" == 1 then
  vim.opt.smoothscroll = true
  -- vim.opt.foldlevel = 99
  -- vim.opt.foldmethod = "expr"
  -- FIXME: 此选项会导致文件打开缓慢
  -- 原因可能是因为需要等待treesitter分析完才能启用
  -- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
end

-- UI
vim.opt.pumheight = 10

vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.laststatus = 3

vim.opt.ruler = false
vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes"

vim.opt.mouse = "" -- disable mouse

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

vim.g.theme = "catppuccin"

-- vim: set ts=2 noexpandtab:

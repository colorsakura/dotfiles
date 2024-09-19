-- Editing
vim.opt.number = true
vim.opt.cursorline = true

vim.opt.clipboard = "unnamedplus"

vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.showbreak = "↳"
vim.opt.whichwrap = "h,l,<,>"

vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.virtualedit = "block"

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true
vim.opt.hlsearch = false

-- Indent
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

-- Folding
vim.opt.foldlevel = 99
if vim.fn.has "nvim-0.10" == 1 then
  vim.opt.smoothscroll = true
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
else
  vim.opt.foldmethod = "indent"
end

-- UI
vim.opt.winblend = 0
vim.opt.pumblend = 0
vim.opt.pumheight = 15

vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.laststatus = 3

vim.opt.ruler = false
vim.opt.signcolumn = "yes"
vim.opt.shortmess = "fimnxsTAIcF"

vim.opt.mouse = "" -- disable mouse

vim.g.border = "rounded"

-- Cache/Log file
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand "$HOME/.cache/nvim/undo"
vim.opt.backupdir = vim.fn.expand "$HOME/.cache/nvim/backup"
vim.opt.viewdir = vim.fn.expand "$HOME/.cache/nvim/view"

vim.lsp.set_log_level "OFF"

-- Rendering
vim.opt.termguicolors = true

-- Misc
vim.opt.history = 1000
vim.opt.wildignorecase = true

vim.opt.ttimeoutlen = 10

vim.g.loaded_gzip = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- TODO:
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

-- Options
vim.g.bigfile_size = 1024 * 1025 * 1.5 -- 1.5 MB

vim.g.fcitx5_rime = 1

vim.g.theme = "catppuccin"

-- Neovide
if vim.g.neovide then
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_theme = vim.g.theme or "onedark"
  vim.g.neovide_transparency = 1
  vim.o.guifont = "Cascadia Code:h13"
end

-- Diagnostic
vim.opt.updatetime = 300
vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float()]]

vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
    },
    texthl = {},
  },
  virtual_text = false,
}

-- vim: set ts=2 noexpandtab:

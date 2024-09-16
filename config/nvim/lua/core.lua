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
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- UI
vim.opt.winblend = 0
vim.opt.pumblend = 0
vim.opt.pumheight = 15

vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.cmdheight = 0
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

if vim.fn.has "nvim-0.10" == 1 then
  vim.opt.smoothscroll = true
  vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
  vim.opt.foldmethod = "expr"
  vim.opt.foldtext = ""
else
  vim.opt.foldmethod = "indent"
  vim.opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
end

vim.g.fcitx5_rime = 1

vim.g.theme = "catppuccin"

-- Neovide
if vim.g.neovide then
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_theme = "onedark"
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

-- Restore cursor position when opening a file
-- https://github.com/neovim/neovim/issues/16339#issuecomment-1457394370
vim.api.nvim_create_autocmd("BufRead", {
  callback = function(opts)
    vim.api.nvim_create_autocmd("BufWinEnter", {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
          not (ft:match "commit" and ft:match "rebase")
          and last_known_line > 1
          and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys('g`"', "nx", false)
        end
      end,
    })
  end,
})


-- vim: set ts=2 noexpandtab:

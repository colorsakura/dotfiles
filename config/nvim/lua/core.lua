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

-- TODO: remove this once https://github.com/nvim-telescope/telescope.nvim/issues/699 is fixed
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.opt.foldmethod:get() == "expr" then vim.schedule(function() vim.opt.foldmethod = "expr" end) end
  end,
})

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

-- Cache/Log file
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand "$HOME/.cache/nvim/undo"
vim.opt.backupdir = vim.fn.expand "$HOME/.cache/nvim/backup"
vim.opt.viewdir = vim.fn.expand "$HOME/.cache/nvim/view"
vim.lsp.set_log_level "off"

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

-- Diagnostic
vim.opt.updatetime = 300
vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float()]]

vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

vim.diagnostic.config {
  virtual_text = true,
  float = { header = "", prefix = "", focusable = false },
  update_in_insert = true,
  severity_sort = true,
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

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "grug-far",
    "help",
    "lspinfo",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "dbout",
    "gitsigns.blame",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Quit buffer",
    })
  end,
})

if vim.loader then vim.loader.enable() end

-- Performance monitoring
local start_time = vim.loop.hrtime()
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local elapsed = (vim.loop.hrtime() - start_time) / 1e6
    vim.notify(string.format("⚡ Neovim started in %.2fms", elapsed), vim.log.levels.INFO)
  end,
})

-- {{{ Global config
local config = {
  treesitter = {
    -- 脚本语言
    "lua",
    "python",
    "javascript",
    "typescript",
    "bash",

    -- 系统语言
    "c",
    "cpp",
    "rust",
    "go",
    "java",

    -- Web 开发
    "html",
    "css",
    "tsx",
    "json",
    "yaml",
    "svelte",

    -- 文档
    "markdown",
    "markdown_inline",

    -- 其他常用
    "sql",
    "dockerfile",
    "toml",
    "vim"
  },
  lsp = {
    -- 系统编程语言
    "clangd",        -- C/C++
    "rust_analyzer", -- Rust
    "zls",           -- Zig
    "gopls",         -- Go

    -- 脚本语言
    "lua_ls", -- Lua
    "ty",     -- Python (类型检查)
    "ruff",   -- Python (linter/formatter)

    -- 移动和桌面应用
    "dartls", -- Dart/Flutter
    "qmlls",  -- QML

    -- Web 开发
    "html",   -- HTML
    "cssls",  -- CSS
    "jsonls", -- JSON
    "ts_ls",  -- TypeScript/JavaScript

    -- 配置和文档
    "yamlls",   -- YAML
    "toml_lsp", -- TOML
    "marksman", -- Markdown

    -- Shell 和脚本
    "bashls", -- Bash
    "vimls",  -- Vim script

    -- 容器和工具
    "dockerls", -- Dockerfile

    -- 数据库
    "sqlls", -- SQL

    -- 其他语言
    "jdtls", -- Java
    "cmake", -- CMake
    "nixd",  -- Nix
  }
}
-- }}}

-- {{{ Options
-- Leader key
vim.g.mapleader = vim.keycode "<space>"
vim.g.maplocalleader = "\\"

-- Disable providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

-- Disable editorconfig
vim.g.editorconfig = false

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
vim.opt.foldlevel = 0
vim.opt.formatoptions = "jcroqlnt"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.jumpoptions = "view"
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.mouse = ""
vim.opt.number = true
vim.opt.pumblend = 10
vim.opt.pumheight = 10
vim.opt.ruler = false
vim.opt.scrolloff = 4
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.shortmess:append { W = true, I = true, c = true, C = true }
vim.opt.showmode = false
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"
vim.opt.spelllang = { "en" }
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 500
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200
vim.opt.virtualedit = "block"
vim.opt.wildmode = "longest:full,full"
vim.opt.winminwidth = 5
vim.opt.modelines = 1
vim.opt.wrap = false
vim.opt.fileencodings = "ucs-bom,utf-8,gbk,gb18030,gb2312,cp936,latin1"
vim.opt.fileformats = "unix,dos,mac"

vim.schedule(function()
  vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
end)

if vim.g.neovide then
  if vim.fn.has "linux" == 1 then vim.opt.guifont = "JetBrains Mono,monospace:h13" end
  if vim.fn.has "win32" == 1 then vim.opt.guifont = "JetBrains Mono NF,monospace:h13" end
end
-- }}}

-- {{{ Plugins
local plugins_group = vim.api.nvim_create_augroup("plugins", { clear = true })
vim.api.nvim_create_autocmd({ "PackChanged" }, {
  group = plugins_group,
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" then
      vim.cmd.packadd(name)
      if kind == "install" then
        vim.schedule(function()
          require("nvim-treesitter").install(config.treesitter)
        end)
      end
      if kind == "update" then
        vim.cmd "TSUpdate"
      end
    end
  end
})

vim.pack.add({
  -- 必须立即加载（语法高亮、主题）
  {
    src = "git@github.com:nvim-treesitter/nvim-treesitter",
    version = "main",
  },
  {
    src = "git@github.com:nvim-treesitter/nvim-treesitter-textobjects",
    version = "main",
  },
  {
    src = "git@github.com:catppuccin/nvim",
    name = "catppuccin",
    version = "main"
  },

  -- LSP 配置（按文件类型触发）
  {
    src = "git@github.com:neovim/nvim-lspconfig",
  },

  -- 补全和自动配对：进入插入模式时加载
  {
    src = "git@github.com:saghen/blink.cmp",
    version = vim.version.range "1.*",
  },
  {
    src = "git@github.com:nvim-mini/mini.pairs",
    version = vim.version.range "*",
  },

  -- snacks：按需加载模块
  {
    src = "git@github.com:folke/snacks.nvim",
    version = vim.version.range "*",
  },

  -- oil：使用时才加载
  {
    src = "git@github.com:stevearc/oil.nvim",
    version = vim.version.range "*",
  },

  -- quicker：quickfix 打开时加载
  {
    src = "git@github.com:stevearc/quicker.nvim",
    version = vim.version.range "*",
  },

  -- leap：按键触发
  {
    src = "https://codeberg.org/andyg/leap.nvim.git",
    version = "main",
  },

  -- UI 组件：立即加载
  {
    src = "git@github.com:nvim-mini/mini.statusline",
    version = vim.version.range "*",
  },
  {
    src = "git@github.com:nvim-mini/mini.notify",
    version = vim.version.range "*",
  },
})

-- Setup catppuccin theme
require("catppuccin").setup({
  default_integrations = false,
  integrations = {
    blink_cmp = true,
    snacks = true,
    leap = true,
  }
})
vim.cmd "colorscheme catppuccin"

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  once = true,
  group = plugins_group,
  callback = function()
    -- 一次性 setup 所有需要的模块
    require("snacks").setup({
      dashboard = {
        sections = {
          { section = "header" },
          { section = "keys",  gap = 1, padding = 1 },
        },
      },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      input = { enabled = true },
      indent = { enabled = false },
      scroll = { enabled = false },
      words = { enabled = false },
      scope = { enabled = false },
    })

    -- 加载其他插件
    require("mini.statusline").setup()
    require("mini.notify").setup()
    require("oil").setup()
    require("quicker").setup()
  end
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = plugins_group,
  pattern = config.treesitter,
  callback = function()
    -- 只在支持 treesitter 的文件类型启动
    pcall(vim.treesitter.start, 0)
    if pcall(function() return vim.treesitter.get_parser() end) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end
})

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  once = true,
  group = plugins_group,
  callback = function()
    require("blink.cmp").setup()
    require("mini.pairs").setup()
  end
})

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
map("n", "<leader>bd", function()
  pcall(function() Snacks.bufdelete() end)
end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function()
  pcall(function() Snacks.bufdelete.other() end)
end, { desc = "Delete Other Buffers" })
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
  vim.cmd "redraw"
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

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
    if client:supports_method "textDocument/foldingRange" and vim.wo.foldmethod ~= "marker" then
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end
    if client:supports_method "textDocument/codeLens" then
      vim.lsp.codelens.refresh()
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        buffer = e.buf,
        callback = vim.lsp.codelens.refresh,
      })
    end

    -- keymaps
    map("n", "K", vim.lsp.buf.hover, { buffer = e.buf, desc = "Hover" })
    map("n", "gd", vim.lsp.buf.definition, { buffer = e.buf, desc = "Goto Definition" })
    map("n", "gD", vim.lsp.buf.declaration, { buffer = e.buf, desc = "Goto Declaration" })
    map("n", "gy", vim.lsp.buf.type_definition, { buffer = e.buf, desc = "Goto TypeDefinition" })
    map("n", "gI", vim.lsp.buf.implementation, { buffer = e.buf, desc = "Goto Implementation" })
    map("n", "grr", vim.lsp.buf.references, { buffer = e.buf, desc = "Goto References" })
    map("n", "grs", vim.lsp.buf.signature_help, { buffer = e.buf, desc = "Signature Help" })
    map("n", "grn", vim.lsp.buf.rename, { buffer = e.buf, desc = "Code Rename" })
    map("n", "gra", vim.lsp.buf.code_action, { buffer = e.buf, desc = "Code Action" })
    map(
      { "n", "x" },
      "grf",
      vim.lsp.buf.format,
      { buffer = e.buf, desc = "Code Format" }
    )
  end,
})

-- plugins keymaps
map({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
map('n', 'S', '<Plug>(leap-from-window)')

map({ 'n' }, '<leader>e', function() require("oil").open_float() end, { desc = "Open Oil" })

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
    "help",
    "lspinfo",
    "notify",
    "oil",
    "qf",
    "startuptime",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    map("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Quit buffer with <q>",
    })
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

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("filetype_settings", { clear = true }),
  pattern = { "man", "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    if ft == "man" then
      vim.bo[ev.buf].buflisted = false
    else
      vim.opt_local.wrap = true
    end
  end,
})

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
vim.lsp.enable(config.lsp)

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN] = '▲',
      [vim.diagnostic.severity.HINT] = '⚑',
      [vim.diagnostic.severity.INFO] = '»',
    },
  },
  virtual_text = {
    prefix = '●'
  },
})
-- }}}

-- vim: set ts=2 fdm=marker:

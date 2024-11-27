require "core"
require "keymaps"
require "autocmds"

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://git.homegu.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  defaults = {
    lazy = true,
  },
  change_detection = {
    enable = true,
    notify = true,
  },
  ui = {
    size = { width = 0.65, height = 0.65 },
    border = vim.g.border or "none",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
      },
    },
  },
})

vim.cmd.colorscheme(vim.g.theme)

-- vim: set ts=2 noexpandtab:

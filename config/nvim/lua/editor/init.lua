local M = {}

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then error("Error cloning lazy.nvim:\n" .. out) end
end
vim.opt.rtp:prepend(lazypath)

-- Profile
if vim.env.PROF then
    local snacks = vim.fn.stdpath "data" .. "/lazy/snacks.nvim"
    vim.opt.rtp:append(snacks)
    ---@diagnostic disable-next-line: missing-fields
    require("snacks.profiler").startup {
        startup = {
            event = "VimEnter",
        },
    }
end

function M.init()
    require("lazy").setup {
        spec = {
            { import = "editor.plugins" },
        },
        defaults = {
            lazy = false,
            version = false, -- always use the latest git commit
        },
        checker = {
            enabled = false, -- check for plugin updates periodically
            notify = true, -- notify on update
        }, -- automatically check for plugin updates
        performance = {
            rtp = {
                -- disable some rtp plugins
                disabled_plugins = {
                    "gzip",
                    "netrwPlugin",
                    "rplugin",
                    "spellfile",
                    "tarPlugin",
                    "tohtml",
                    "tutor",
                    "zipPlugin",
                    -- "matchit",
                    -- "matchparen",
                    -- "matchit",
                    -- "matchparen",
                },
            },
        },
        install = {
            missing = false,
        },
        rocks = {
            enabled = false,
        },
    }
end

function M.setup()
    M.init()
    Editor.plugin.setup()
    Editor.root.setup()

    Editor.ime.setup()
end

_G.Editor = require "editor.util"

return M

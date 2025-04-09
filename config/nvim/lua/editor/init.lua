_G.Editor = require "editor.util"

local M = {}

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
    Editor.plugin.setup()
    M.init()
    Editor.root.setup()

    vim.schedule(function() Editor.ime.setup() end)
end

return M

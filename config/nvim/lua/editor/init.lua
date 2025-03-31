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
            enabled = true, -- check for plugin updates periodically
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
                },
            },
        },
        ui = {
            winborder = vim.g.winborder or nil,
        },
        install = {
            missing = true,
        },
    }
end

function M.setup()
    Editor.plugin.setup()
    M.init()
    Editor.root.setup()
    Editor.ime.setup()
end

return M

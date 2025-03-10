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
            {
                "folke/snacks.nvim",
                lazy = true,
                event = { "VeryLazy" },
                opts = {
                    dashboard = { enabled = true },
                },
                config = function(_, opts) require("snacks").setup(opts) end,
            },
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
                    -- "matchit",
                    -- "matchparen",
                    "netrwPlugin",
                    "tarPlugin",
                    "tohtml",
                    "tutor",
                    "zipPlugin",
                },
            },
        },
        ui = {
            border = vim.g.border or nil,
        },
        install = {
            missing = true,
        },
    }
end

function M.setup()
    M.init()

    vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("editor.setup", { clear = true }),
        pattern = "VeryLazy",
        callback = function()
            Editor.root.setup()
            Editor.ime.setup()
        end,
    })
end

return M

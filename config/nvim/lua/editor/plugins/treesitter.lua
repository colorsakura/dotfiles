return {
    {
        "folke/which-key.nvim",
        opts = {
            spec = {
                { "<BS>", desc = "Decrement Selection", mode = "x" },
                { "<c-space>", desc = "Increment Selection", mode = { "x", "n" } },
            },
        },
    },

    -- Treesitter is a new parser generator tool that we can
    -- use in Neovim to power faster and more accurate
    -- syntax highlighting.
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        branch = "main",
        build = ":TSUpdate",
        lazy = false, -- 此插件不支持 LazyLoad
        opts_extend = { "ensure_installed" },
        ---@type TSConfig
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            ensure_installed = { "stable", "unstable" },
            ignore_install = { "unsupported" },
        },
        config = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                opts.ensure_installed = Editor.dedup(opts.ensure_installed)
            end
            require("nvim-treesitter").setup(opts)
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        lazy = true,
        branch = "main",
        event = "VeryLazy",
        ---@class TSTextObjects.Config
        opts = {},
        config = function(_, opts)
            require("nvim-treesitter-textobjects").setup(opts)
            vim.keymap.set(
                { "x", "o" },
                "af",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
                end,
                { desc = "function.outer" }
            )
            vim.keymap.set(
                { "x", "o" },
                "if",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
                end,
                { desc = "function.inner" }
            )
            vim.keymap.set(
                { "x", "o" },
                "ac",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
                end,
                { desc = "class.outer" }
            )
            vim.keymap.set(
                { "x", "o" },
                "ic",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
                end,
                { desc = "class.inner" }
            )
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        lazy = true,
        event = { "VeryLazy" },
        cmd = { "TSContextEnable" },
        opts = function()
            local tsc = require "treesitter-context"
            Snacks.toggle({
                name = "Context",
                get = tsc.enabled,
                set = function(state)
                    if state then
                        tsc.enable()
                    else
                        tsc.disable()
                    end
                end,
            }):map "<leader>uc"

            return {
                enable = true,
            }
        end,
        config = function(_, opts) require("treesitter-context").setup(opts) end,
    },
}

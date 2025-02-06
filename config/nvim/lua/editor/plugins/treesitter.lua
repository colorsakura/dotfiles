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
        event = { "VeryLazy" },
        lazy = false, -- 此插件不支持 LazyLoad
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        opts_extend = { "ensure_installed" },
        ---@type TSConfig
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "css",
                "diff",
                "go",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "jsonc",
                "lua",
                "luadoc",
                "luap",
                "markdown",
                "markdown_inline",
                "printf",
                "python",
                "query",
                "regex",
                "rust",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "xml",
                "yaml",
                "zig",
            },
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
        config = function(_, opts) require("nvim-treesitter-textobjects").setup(opts) end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        lazy = true,
        events = { "VeryLazy" },
        cmd = { "TSContextEnable" },
        opts = function()
            local tsc = require "treesitter-context"
            Snacks.toggle({
                name = "Treesitter Context",
                get = tsc.enabled,
                set = function(state)
                    if state then
                        tsc.enable()
                    else
                        tsc.disable()
                    end
                end,
            }):map "<leader>ut"

            return {
                enable = true,
            }
        end,
        config = function(_, opts) require("treesitter-context").setup(opts) end,
    },
}

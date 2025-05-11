return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        branch = "main",
        build = ":TSUpdate",
        lazy = false, -- 此插件不支持 LazyLoad
        ---@type TSConfig
        ---@diagnostic disable-next-line: missing-fields
        opts = {},
        config = function(_, opts)
            local parsers = vim.tbl_deep_extend(
                "force",
                opts.ensure_installed,
                Editor.opts("nvim-treesitter").ensure_installed or {}
            )
            require("nvim-treesitter").install(parsers)
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
            -- select {{{
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
                { desc = "inner function" }
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
                { desc = "inner class" }
            )
            --- }}}
            -- move {{{
            vim.keymap.set(
                { "n", "x", "o" },
                "]m",
                function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects") end,
                { desc = "Next function start" }
            )
            vim.keymap.set(
                { "n", "x", "o" },
                "[m",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
                end,
                { desc = "Prev function start" }
            )
            vim.keymap.set(
                { "n", "x", "o" },
                "]M",
                function() require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects") end,
                { desc = "Next function end" }
            )
            vim.keymap.set(
                { "n", "x", "o" },
                "[M",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
                end,
                { desc = "Prev function end" }
            )
            vim.keymap.set(
                { "n", "x", "o" },
                "]]",
                function() require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects") end,
                { desc = "Next class" }
            )
            vim.keymap.set(
                { "n", "x", "o" },
                "[[",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
                end,
                { desc = "Prev class" }
            )
            -- You can also pass a list to group multiple queries.
            vim.keymap.set(
                { "n", "x", "o" },
                "]o",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start(
                        { "@loop.inner", "@loop.outer" },
                        "textobjects"
                    )
                end
            )
            vim.keymap.set(
                { "n", "x", "o" },
                "]s",
                function() require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals") end
            )
            vim.keymap.set(
                { "n", "x", "o" },
                "]z",
                function() require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds") end
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
                max_lines = 5,
            }
        end,
        config = function(_, opts) require("treesitter-context").setup(opts) end,
    },
}

-- vim: fdm=marker

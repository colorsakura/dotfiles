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
        version = false, -- last release is way too old and doesn't work on Windows
        build = ":TSUpdate",
        event = { "VeryLazy", "VeryLazy" },
        lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
        init = function(plugin)
            require("lazy.core.loader").add_to_rtp(plugin)
            require "nvim-treesitter.query_predicates"
        end,
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        keys = {
            { "<c-space>", desc = "Increment Selection" },
            { "<bs>", desc = "Decrement Selection", mode = "x" },
        },
        opts_extend = { "ensure_installed" },
        ---@type TSConfig
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = false },
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
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
            textobjects = {
                move = {
                    enable = true,
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                        ["]a"] = "@parameter.inner",
                    },
                    goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                        ["[a"] = "@parameter.inner",
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                        ["[A"] = "@parameter.inner",
                    },
                },
            },
        },
        config = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                opts.ensure_installed = Editor.dedup(opts.ensure_installed)
            end
            require("nvim-treesitter.configs").setup(opts)
            require("treesitter-context").setup()
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        lazy = true,
        event = "VeryLazy",
        config = function()
            -- If treesitter is already loaded, we need to run config again for textobjects
            if Editor.is_loaded "nvim-treesitter" then
                local opts = Editor.opts "nvim-treesitter"
                require("nvim-treesitter.configs").setup { textobjects = opts.textobjects }
            end

            -- When in diff mode, we want to use the default
            -- vim text objects c & C instead of the treesitter ones.
            local move = require "nvim-treesitter.textobjects.move" ---@type table<string,fun(...)>
            local configs = require "nvim-treesitter.configs"
            for name, fn in pairs(move) do
                if name:find "goto" == 1 then
                    move[name] = function(q, ...)
                        if vim.wo.diff then
                            local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
                            for key, query in pairs(config or {}) do
                                if q == query and key:find "[%]%[][cC]" then
                                    vim.cmd("normal! " .. key)
                                    return
                                end
                            end
                        end
                        return fn(q, ...)
                    end
                end
            end
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        lazy = true,
        events = { "VeryLazy" },
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
    },
}
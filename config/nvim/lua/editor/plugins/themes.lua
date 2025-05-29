return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
        priority = 1000,
        build = ":CatppuccinCompile",
        opts = function()
            return {
                flavour = "mocha",
                -- transparent_background = true,
                integrations = {
                    blink_cmp = true,
                    -- dap = true,
                    -- dap_ui = true,
                    diffview = true,
                    flash = true,
                    -- fzf = true,
                    gitsigns = true,
                    grug_far = true,
                    lsp_trouble = true,
                    markdown = true,
                    mason = true,
                    mini = true,
                    native_lsp = {
                        enabled = true,
                    },
                    neotree = true,
                    neotest = true,
                    noice = true,
                    notify = true,
                    overseer = true,
                    render_markdown = true,
                    treesitter = true,
                    treesitter_context = true,
                    semantic_tokens = true,
                    snacks = {
                        enabled = true,
                    },
                    which_key = true,
                },
            }
        end,
        config = function(_, opts) require("catppuccin").setup(opts) end,
    },
}

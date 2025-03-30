return {
    {
        "folke/tokyonight.nvim",
        lazy = true,
        priority = 1000,
        opts = {
            -- transparent = true,
        },
        config = function(_, opts) require("tokyonight").setup(opts) end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
        priority = 1000,
        build = ":CatppuccinCompile",
        opts = function()
            return {
                flavour = "mocha",
                background = { light = "latte", dark = "mocha" },
                -- transparent_background = true,
                term_colors = true,
                styles = {
                    comments = { "italic" },
                    conditionals = { "italic" },
                },
                integrations = {
                    bufferline = true,
                    barbar = true,
                    blink_cmp = true,
                    cmp = true,
                    dap = { enabled = true, enable_ui = true },
                    fidget = true,
                    fzf = true,
                    gitsigns = true,
                    grug_far = true,
                    illuminate = true,
                    indent_blankline = { enabled = true },
                    lsp_trouble = true,
                    markdown = true,
                    mason = true,
                    mini = true,
                    native_lsp = {
                        enabled = true,
                        underlines = {
                            errors = { "undercurl" },
                            hints = { "undercurl" },
                            warnings = { "undercurl" },
                            information = { "undercurl" },
                        },
                    },
                    neotree = true,
                    neotest = true,
                    noice = true,
                    notify = true,
                    rainbow_delimiters = true,
                    render_markdown = true,
                    ufo = true,
                    telescope = true,
                    treesitter = true,
                    treesitter_context = true,
                    snacks = {
                        enabled = true,
                    },
                    which_key = true,
                },
                custom_highlights = function(colors)
                    Core.config.highlight.TabIndicatorActive = { fg = colors.blue }
                    Core.config.highlight.StlModeNormal = { fg = colors.blue }
                    Core.config.highlight.StlModeInsert = { fg = colors.peach }
                    Core.config.highlight.StlModeVisual = {}
                    Core.config.highlight.StlModeReplace = {}
                    Core.config.highlight.StlModeCommand = {}
                    Core.config.highlight.StlModeTerminal = {}
                    Core.config.highlight.StlModePending = {}
                    return {}
                end,
            }
        end,
        config = function(_, opts) require("catppuccin").setup(opts) end,
    },
}

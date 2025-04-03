return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
        priority = 1000,
        build = ":CatppuccinCompile",
        opts = function()
            local hl = Core.config.highlight
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
                custom_highlights = function(c)
                    hl.TabIndicatorActive = { fg = c.blue }
                    hl.StlModeNormal = { fg = c.blue }
                    hl.StlModeInsert = { fg = c.peach }
                    hl.StlModeVisual = {}
                    hl.StlModeReplace = {}
                    hl.StlModeCommand = {}
                    hl.StlModeTerminal = {}
                    hl.StlModePending = {}
                    hl.NoiceCmdline = { bg = c.mantle }
                    return {}
                end,
            }
        end,
        config = function(_, opts) require("catppuccin").setup(opts) end,
    },
}

return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = {},
    config = function(_, opts) require("tokyonight").setup(opts) end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
    build = ":CatppuccinCompile",
    opts = {
      flavour = "mocha",
      background = { light = "latte", dark = "mocha" },
      term_colors = true,
      integrations = {
        bufferline = false,
        cmp = true,
        dap = { enabled = true, enable_ui = true },
        fidget = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        markdown = true,
        mason = true,
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
        noice = true,
        notify = true,
        rainbow_delimiters = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
      },
    },
    config = function(_, opts) require("catppuccin").setup(opts) end,
  },

  {
    "navarasu/onedark.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      transparent = false,
      style = "deep",
    },
    config = function(_, opts)
      require("onedark").setup(opts)
      require("onedark").load()
    end,
  },
}

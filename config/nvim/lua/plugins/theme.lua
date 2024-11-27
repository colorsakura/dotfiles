return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      transparent = true,
    },
    config = function(_, opts) require("tokyonight").setup(opts) end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    build = ":CatppuccinCompile",
    opts = {
      flavour = "mocha",
      background = { light = "latte", dark = "mocha" },
      transparent_background = true,
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
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    priority = 1000,
    config = function() require("github-theme").setup {} end,
  },
}

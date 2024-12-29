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
    opts = {
      flavour = "mocha",
      background = { light = "latte", dark = "mocha" },
      -- transparent_background = true,
      term_colors = true,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
      integrations = {
        bufferline = false,
        barbar = true,
        blink_cmp = true,
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

  -- TODO: 为 treesitter_context 设置颜色组
  -- FIXME: onedarkpro 不支持blink highlights
  {
    "olimorris/onedarkpro.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      highlights = {},
      styles = {
        comments = "italic",
      },
      options = {
        cursorline = true,
        transparent = false,
        lualine_transparency = false,
        highlight_inactive_windows = true,
      },
    },
    config = function(_, opts) require("onedarkpro").setup(opts) end,
  },
  {
    "projekt0n/github-nvim-theme",
    lazy = true,
    name = "github-theme",
    priority = 1000,
    config = function() require("github-theme").setup {} end,
  },
  -- TODO: virtual text 与其他文本无差异
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = true,
    priority = 1000,
    config = function() end,
  },
}

---@type LazySpec
return {
  "lilydjwg/fcitx.vim",
  {
    "MeanderingProgrammer/markdown.nvim",
    opts = {
      enabled = false,
    },
    config = function(_, opts) require("render-markdown").setup(opts) end,
  },
  {
    "brenoprata10/nvim-highlight-colors",
    config = function(_, opts) require("nvim-highlight-colors").setup(opts) end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
    },
    keys = {
      {
        "<leader>?",
        function() require("which-key").show { global = false } end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "yianwillis/vimcdoc",
    event = { "VeryLazy" },
  },
}

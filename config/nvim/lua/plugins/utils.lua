return {
  {
    "mg979/vim-visual-multi",
    events = { "VeryLazy" },
    keys = { { "<C-n>", mode = { "n", "x" } } },
  },
  {
    "akinsho/toggleterm.nvim",
    lazy = false,
    events = { "VeryLazy" },
    opts = {
      open_mapping = [[<c-\>]],
    },
    config = function(_, opts) require("toggleterm").setup(opts) end,
  },
}

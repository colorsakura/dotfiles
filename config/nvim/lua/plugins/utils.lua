return {
  {
    "mg979/vim-visual-multi",
    lazy = true,
    keys = { { "<C-n>", mode = { "n", "x" } } },
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {
      open_mapping = [[<c-\>]],
    },
    config = function(_, opts) require("toggleterm").setup(opts) end,
  },
}

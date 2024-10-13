return {
  -- WorkTree
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    event = { "VeryLazy" },
    keys = {
      {
        "<leader>e",
        "<cmd>Neotree toggle reveal<cr>",
        desc = "File manager",
      },
    },
    opts = {
      window = {
        width = 30,
      },
    },
    config = function(_, opts) require("neo-tree").setup(opts) end,
  },
}

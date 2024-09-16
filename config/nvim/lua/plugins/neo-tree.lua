return {
  -- WorkTree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    event = { "VeryLazy" },
    keys = {
      {
        "<leader>e",
        "<cmd>Neotree toggle<cr>",
        desc = "Neotree",
      },
    },
    opts = {
      window = {
        width = 28,
      },
    },
    config = function(_, opts) require("neo-tree").setup(opts) end,
  },
}

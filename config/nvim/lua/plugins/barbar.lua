return {
  -- Tab page
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
      "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
    },
    event = { "VeryLazy" },
    opts = {
      siderbar_filetypes = {
        ["neo-tree"] = { event = "BufWipeout" },
      },
      icons = {
        filetype = {
          enabled = false,
        },
      },
    },
    config = function(_, opts) require("barbar").setup(opts) end,
    exclude_ft = { "alpha" },
  },
}

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function() require("which-key").show { global = false } end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    config = function(_, opts)
      local wk = require "which-key"
      wk.add({ "<leader>b", group = "Buffer" }, { "<leader>t", group = "Telescope" }, { "<leader>w", group = "Window" })
      wk.setup(opts)
    end,
  },
}

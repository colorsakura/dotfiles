return {
  -- Dashboard
  {
    "goolord/alpha-nvim",
    event = { "BufEnter" },
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
      local dashboard = require "alpha.themes.dashboard"
      require("alpha").setup(dashboard.config)
    end,
  },
}

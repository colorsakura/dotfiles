return {
  -- Go development
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    "lilydjwg/fcitx.vim",
    event = "InsertEnter",
  },
  {
    "b0o/incline.nvim",
    opts = {},
    -- Optional: Lazy load Incline
    event = "VeryLazy",
  },
}

return {
  { "nvim-lua/plenary.nvim" },
  {
    "akinsho/toggleterm.nvim",
    lazy = true,
    events = { "VeryLazy" },
    keys = { { "<c-\\>", "<cmd>ToggleTerm<cr>" } },
    opts = {
      open_mapping = [[<c-\>]],
    },
    config = function(_, opts) require("toggleterm").setup(opts) end,
  },
  {
    "folke/persistence.nvim",
    lazy = true,
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>qS", function() require("persistence").select() end, desc = "Select Session" },
      { "<leader>ql", function() require("persistence").load { last = true } end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
  -- Sorting plugin that supports line-wise and delimiter sorting
  {
    "sQVe/sort.nvim",
    lazy = true,
    events = { "LazyFile" },
    keys = {
      { "gos", ":Sort<CR>", mode = "n", desc = "Sort", silent = true },
      { "gos", "<Esc>:Sort<CR>", mode = "v", desc = "Sort", silent = true },
    },
  },
  -- { import = "plugins.lang.go" },
  { import = "plugins.lang.yaml" },
  { import = "plugins.lang.json" },
  -- { import = "plugins.lang.tex" },
  { import = "plugins.lang.markdown" },
  { import = "plugins.extras.ai.codeium" },
  -- { import = "plugins.extras.ai.supermaven" },
  -- { import = "plugins.extras.ai.codecompanion" },
  { import = "plugins.extras.ai.avante" },
}

return {
  {
    "ibhagwan/fzf-lua",
    lazy = true,
    cmd = { "FzfLua" },
    events = "VeryLazy",
    opts = {
      winopts = {
        border = "single",
        width = 0.8,
        height = 0.8,
        row = 0.5,
        col = 0.5,
        preview = {
          border = "single",
          scrollchars = { "┃", "" },
        },
        treesitter = {
          enabled = true,
        },
      },
    },
    keys = {
      -- find
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files" },
      { "<leader>f/", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },
      { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
      -- git
      { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Commits" },
      { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Status" },
      -- search
    },
    init = function()
      require("lazy").load { plugins = { "fzf-lua" } }
      require("fzf-lua").register_ui_select()
    end,
    config = function(_, opts)
      require("fzf-lua").setup(opts)
      require("fzf-lua").register_ui_select()
    end,
  },
}

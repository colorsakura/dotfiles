return {
  -- NOTE: AI 为cmp提供的补全代码并不完整, 因此使用inline completion 代替
  {
    "supermaven-inc/supermaven-nvim",
    lazy = false,
    events = "VeryLazy",
    cmd = { "SupermavenUseFree" },
    opts = function()
      return {
        keymaps = {
          accept_suggestion = "<C-Enter>",
          clear_suggestion = "<C-l>",
        },
        ignore_filetypes = { "bigfile", "markdown" },
        disable_inline_completion = false,
      }
    end,
    config = function(_, opts) require("supermaven-nvim").setup(opts) end,
  },
}

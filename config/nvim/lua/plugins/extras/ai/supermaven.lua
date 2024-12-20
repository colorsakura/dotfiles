return {
  -- README: AI 为cmp提供的补全代码并不完整, 因此使用inline completion 代替
  {
    "supermaven-inc/supermaven-nvim",
    lazy = true,
    events = "InsertEnter",
    cmd = { "SupermavenUseFree" },
    opts = function()
      return {
        keymaps = {
          accept_suggestion = "<C-Enter>", -- handled by nvim-cmp / blink.cmp
          clear_suggestion = "<C-l>",
        },
        ignore_filetypes = { "bigfile", "markdown" },
        disable_inline_completion = false,
      }
    end,
    config = function(_, opts) require("supermaven-nvim").setup(opts) end,
  },
}

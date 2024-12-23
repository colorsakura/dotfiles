return {
  {
    "mason.nvim",
    lazy = true,
    optional = true,
    opts = function()
      return {
        ensure_installed = { "texlab" },
      }
    end,
  },
}

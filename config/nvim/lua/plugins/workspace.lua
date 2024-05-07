return {
  {
    "nvimdev/template.nvim",
    cmd = { "Template", "TemProject" },
    opts = {},
    config = function()
      require("template").setup({})
    end,
  },
  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        ["c"] = { "clang_format" },
        ["cpp"] = { "clang_format" },
      },
    },
  },
}

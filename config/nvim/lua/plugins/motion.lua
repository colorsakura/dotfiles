return {
  {
    "ggandor/leap.nvim",
    enabled = false,
    event = { "VeryLazy" },
    config = function() require("leap").create_default_mappings() end,
  },
}

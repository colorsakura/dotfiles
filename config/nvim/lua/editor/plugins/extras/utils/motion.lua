return {
    {
        "ggandor/leap.nvim",
        enabled = false,
        event = { "VeryLazy" },
        config = function() require("leap").create_default_mappings() end,
    },
    {
        "mg979/vim-visual-multi",
        event = { "VeryLazy" },
        keys = { { "<C-n>", mode = { "n", "x" } } },
    },
}

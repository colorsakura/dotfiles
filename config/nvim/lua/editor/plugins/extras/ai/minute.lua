return {
    {
        "milanglacier/minuet-ai.nvim",
        lazy = true,
        event = "VeryLazy",
        dependencies = { "plenary.nvim" },
        opts = {},
        config = function(_, opts) require("minuet").setup(opts) end,
    },
}

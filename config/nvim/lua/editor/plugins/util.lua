return {
    { "nvim-lua/plenary.nvim" },
    {
        "yianwillis/vimcdoc",
        lazy = true,
        event = "VeryLazy",
        cond = false,
        config = false,
    },
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        event = "VeryLazy",
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("editor.navic.attach", { clear = true }),
                callback = function(args)
                    local navic = require "nvim-navic"
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client and client.server_capabilities.documentSymbolProvider then navic.attach(client, bufnr) end
                end,
            })
        end,
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
            {
                "<leader>qd",
                function() require("persistence").stop() end,
                desc = "Don't Save Current Session",
            },
        },
    },
    {
        "norcalli/nvim-colorizer.lua",
        lazy = true,
        cond = false,
        ft = { "conf", "css", "lua" },
        opts = {
            "css",
            "lua",
            "conf",
        },
        config = function(_, opts) require("colorizer").setup(opts) end,
    },
    {
        dir = "~/Projects/Trans.nvim",
        build = function() require("Trans").install() end,
        keys = {
            -- 可以换成其他你想映射的键
            { "<leader>ct", mode = { "n", "x" }, "<Cmd>Translate<CR>", desc = "󰊿 Translate" },
            { "<leader>cP", mode = { "n", "x" }, "<Cmd>TransPlay<CR>", desc = " Auto Play" },
            -- 目前这个功能的视窗还没有做好，可以在配置里将view.i改成hover
            -- { 'mi', '<Cmd>TranslateInput<CR>', desc = '󰊿 Translate From Input' },
        },
        dependencies = { "kkharji/sqlite.lua" },
        opts = {
            -- your configuration there
        },
    },
    -- { import = "editor.plugins.lang.json" },
    -- { import = "editor.plugins.lang.tex" },
    -- { import = "editor.plugins.lang.yaml" },
    { import = "editor.plugins.lang.c" },
    { import = "editor.plugins.lang.go" },
    { import = "editor.plugins.lang.fish" },
    { import = "editor.plugins.lang.markdown" },
    { import = "editor.plugins.lang.python" },
    { import = "editor.plugins.lang.rust" },
    { import = "editor.plugins.lang.schema" },
    { import = "editor.plugins.lang.zig" },
    { import = "editor.plugins.extras.ai.avante" },
    -- { import = "editor.plugins.extras.ai.codeium" },
    { import = "editor.plugins.extras.ai.supermaven" },
    -- { import = "editor.plugins.extras.ai.codecompanion" },
}

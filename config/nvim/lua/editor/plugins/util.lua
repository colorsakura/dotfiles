return {
    { "nvim-lua/plenary.nvim" },
    {
        "yianwillis/vimcdoc",
        lazy = true,
        event = "VeryLazy",
        -- cond = false,
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
        "obsidian-nvim/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
        --   -- refer to `:h file-pattern` for more examples
        --   "BufReadPre path/to/my-vault/*.md",
        --   "BufNewFile path/to/my-vault/*.md",
        -- },
        dependencies = {
            -- Required.
            "nvim-lua/plenary.nvim",

            -- see below for full list of optional dependencies 👇
        },
        opts = {
            workspaces = {
                {
                    name = "personal",
                    path = "~/Onedrive/Documents/Obsidian",
                },
            },
            disable_frontmatter = true,
            completion = {
                nvim_cmp = false,
                blink = true,
            },
            picker = {
                name = "fzf-lua",
            },
        },
    },
    {
        "folke/persistence.nvim",
        lazy = true,
        event = "BufReadPre",
        opts = {},
        keys = {
            { "<leader>Qs", function() require("persistence").load() end, desc = "Restore Session" },
            { "<leader>QS", function() require("persistence").select() end, desc = "Select Session" },
            { "<leader>Ql", function() require("persistence").load { last = true } end, desc = "Restore Last Session" },
            {
                "<leader>Qd",
                function() require("persistence").stop() end,
                desc = "Don't Save Current Session",
            },
        },
    },
    {
        "brenoprata10/nvim-highlight-colors",
        lazy = true,
        opts = {},
        config = function(_, opts) require("nvim-highlight-colors").setup(opts) end,
    },
    {
        "jake-stewart/auto-cmdheight.nvim",
        lazy = false,
        opts = {
            -- max cmdheight before displaying hit enter prompt.
            max_lines = 5,

            -- number of seconds until the cmdheight can restore.
            duration = 2,

            -- whether key press is required to restore cmdheight.
            remove_on_key = true,

            -- always clear the cmdline after duration and key press.
            -- by default it will only happen when cmdheight changed.
            clear_always = false,
        },
    },
    -- {
    --     dir = "~/Projects/Trans.nvim",
    --     build = function() require("Trans").install() end,
    --     keys = {
    --         -- 可以换成其他你想映射的键
    --         { "<leader>ct", mode = { "n", "x" }, "<Cmd>Translate<CR>", desc = "󰊿 Translate" },
    --         { "<leader>cP", mode = { "n", "x" }, "<Cmd>TransPlay<CR>", desc = " Auto Play" },
    --         -- 目前这个功能的视窗还没有做好，可以在配置里将view.i改成hover
    --         -- { 'mi', '<Cmd>TranslateInput<CR>', desc = '󰊿 Translate From Input' },
    --     },
    --     dependencies = { "kkharji/sqlite.lua" },
    --     opts = {
    --         -- your configuration there
    --     },
    -- },
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

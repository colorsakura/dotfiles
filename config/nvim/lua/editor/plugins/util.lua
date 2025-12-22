return {
    { "nvim-lua/plenary.nvim" },
    {
        "m4xshen/hardtime.nvim",
        lazy = false,
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            enabled = false,
        },
    },
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
        "obsidian-nvim/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        cond = false,
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
            new_notes_location = "E临时笔记",
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
            daily_notes = {
                folder = "D每日笔记",
            },
            --- @return table
            note_frontmatter_func = function(note)
                local front = { tags = note.tags }

                -- TODO: 自动更新日期
                if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                    for k, v in pairs(note.metadata) do
                        front[k] = v
                    end
                end

                return front
            end,
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
    { import = "editor.plugins.extras.ai.avante" },
    { import = "editor.plugins.extras.ai.codeium" },
    { import = "editor.plugins.extras.ai.supermaven" },
    -- { import = "editor.plugins.extras.ai.codecompanion" },
}

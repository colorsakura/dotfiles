local M = {}

function M.setup()
    vim.pack.add({
        {
            src = "git@github.com:nvim-treesitter/nvim-treesitter",
            version = "main",
            lazy = false,
        },
        {
            src = "git@github.com:catppuccin/nvim",
            name = "catppuccin",
            version = "main",
            lazy = false,
        },
        {
            src = "git@github.com:neovim/nvim-lspconfig",
        },
        {
            src = "git@github.com:saghen/blink.cmp",
            version = vim.version.range "1.*",
            lazy = true,
        },
        {
            src = "git@github.com:saghen/blink.pairs",
            version = "main",
            lazy = true,
        },
        {
            src = "git@github.com:folke/snacks.nvim",
            version = "main",
            lazy = true,
        },
    }, {})
end

function M.load()
    require("catppuccin").setup {
        flavour = "auto",
        integrations = {
            blink_cmp = true,
            diffview = true,
            flash = true,
            fzf = true,
            gitsigns = true,
            grug_far = true,
            markdown = true,
            mason = true,
            mini = true,
            native_lsp = {
                enabled = true,
            },
            neotree = true,
            noice = true,
            notify = true,
            overseer = true,
            render_markdown = true,
            treesitter = true,
            treesitter_context = true,
            snacks = {
                enabled = true,
            },
            which_key = true,
        },
    }

    require("blink.cmp").setup {
        appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = "mono",
        },
        signature = {
            enabled = true,
            window = {
                show_documentation = false,
            },
        },
        fuzzy = {
            implementation = "prefer_rust",
            prebuilt_binaries = {
                force_version = "v1.8.0",
            },
        },
        keymap = {
            ["<Tab>"] = {
                function(ctx)
                    if ctx.snippet_active() then
                        return ctx.accept()
                    else
                        return ctx.select_next()
                    end
                end,
                "snippet_forward",
                "fallback",
            },
            ["<S-Tab>"] = {
                function(ctx)
                    if ctx.is_visible() then return ctx.select_prev() end
                end,
                "fallback",
            },
            -- TODO: 当有补全窗口时，需要使用<C-Tab>来进行缩进
            ["<C-Tab>"] = {
                function(ctx)
                    if ctx.is_visible() then vim.api.nvim_feedkeys("\t", "i", true) end
                end,
                "fallback",
            },
            ["<CR>"] = { "accept", "fallback" },
            ["<C-e>"] = { "show", "hide", "fallback" },
        },
        completion = {
            accept = {
                auto_brackets = { enabled = false },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
            },
            menu = {
                draw = {
                    columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
                    treesitter = { "lsp" },
                },
                scrollbar = true,
            },
            list = {
                selection = {
                    preselect = false,
                    auto_insert = true,
                },
            },
            -- README: 虚拟文本用于显示 AI 插件提供的补全选项
            ghost_text = { enabled = false },
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },

        cmdline = {
            completion = {
                menu = {
                    auto_show = true,
                },
                list = {
                    selection = {
                        preselect = false,
                    },
                },
            },
            keymap = {
                ["<Tab>"] = {
                    function(ctx)
                        if ctx.is_visible() then return ctx.select_next() end
                    end,
                    "fallback",
                },
                ["<S-Tab>"] = {
                    function(ctx)
                        if ctx.is_visible() then return ctx.select_prev() end
                    end,
                    "fallback",
                },
                ["<CR>"] = { "fallback" },
            },
        },
    }

    require("snacks").setup {
        dashboard = {
            preset = {
                keys = {
                    {
                        icon = " ",
                        key = "f",
                        desc = "Find File",
                        action = ":lua Snacks.dashboard.pick('files')",
                    },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    {
                        icon = " ",
                        key = "g",
                        desc = "Find Text",
                        action = ":lua Snacks.dashboard.pick('live_grep')",
                    },
                    {
                        icon = " ",
                        key = "r",
                        desc = "Recent Files",
                        action = ":lua Snacks.dashboard.pick('oldfiles')",
                    },
                    {
                        icon = " ",
                        key = "c",
                        desc = "Config",
                        action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
                    },
                    { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
            sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
            },
        },

        bigfile = {
            setup = function(ctx)
                if vim.fn.exists ":NoMatchParen" ~= 0 then vim.cmd [[NoMatchParen]] end
                Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
                vim.b.completion = false -- disable completion
                vim.b.minianimate_disable = true
                vim.b[ctx.buf].minidiff_disable = true -- disable minidiff
                vim.opt_local.foldmethod = "manual"
                vim.schedule(function()
                    if vim.api.nvim_buf_is_valid(ctx.buf) then vim.bo[ctx.buf].syntax = ctx.ft end
                end)
            end,
        },
        indent = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        rename = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = false },
        statuscolumn = { enabled = true },
    }
end

return M

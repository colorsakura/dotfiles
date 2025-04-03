return {
    -- blink.cmp for completion
    {
        "saghen/blink.cmp",
        lazy = true,
        event = { "VeryLazy" },
        version = "v1.*",
        opts_extend = {
            "sources.default",
            "sources.compat",
        },
        dependencies = {
            "rafamadriz/friendly-snippets",
            {
                "saghen/blink.compat",
                lazy = true,
                optional = true, -- make optional so it's only enabled if any extras need it
                opts = {},
                version = "*",
            },
        },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
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
                compat = {},
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
        },
        config = function(_, opts)
            -- setup compat sources
            local enabled = opts.sources.default
            for _, source in ipairs(opts.sources.compat or {}) do
                opts.sources.providers[source] = vim.tbl_deep_extend(
                    "force",
                    { name = source, module = "blink.compat.source" },
                    opts.sources.providers[source] or {}
                )
                if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
                    table.insert(enabled, source)
                end
            end
            opts.sources.compat = nil

            -- check if we need to override symbol kinds
            for _, provider in pairs(opts.sources.providers or {}) do
                ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
                if provider.kind then
                    local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                    local kind_idx = #CompletionItemKind + 1

                    CompletionItemKind[kind_idx] = provider.kind
                    CompletionItemKind[provider.kind] = kind_idx

                    ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
                    local transform_items = provider.transform_items
                    ---@param ctx blink.cmp.Context
                    ---@param items blink.cmp.CompletionItem[]
                    provider.transform_items = function(ctx, items)
                        items = transform_items and transform_items(ctx, items) or items
                        for _, item in ipairs(items) do
                            item.kind = kind_idx or item.kind
                        end
                        return items
                    end

                    provider.kind = nil
                end
            end
            require("blink.cmp").setup(opts)
        end,
    },
    -- add icons
    {
        "saghen/blink.cmp",
        opts = function(_, opts)
            opts.appearance = opts.appearance or {}
            opts.appearance.kind_icons =
                vim.tbl_extend("force", opts.appearance.kind_icons or {}, Core.config.icons.kinds)
        end,
    },
    -- Snippets
    {
        "blink.nvim",
        optional = true,
        dependencies = {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            event = { "InsertEnter" },
            dependencies = {
                "rafamadriz/friendly-snippets",
            },
            config = function()
                vim.schedule(function() require("luasnip.loaders.from_vscode").lazy_load() end)
                vim.schedule(
                    function()
                        require("luasnip.loaders.from_vscode").lazy_load {
                            paths = "snippets",
                        }
                    end
                )
            end,
        },
        opts = {
            snippets = {
                preset = "luasnip",
            },
            history = true,
            delete_check_events = "TextChanged",
        },
    },
    -- comments
    {
        "folke/ts-comments.nvim",
        lazy = true,
        event = "VeryLazy",
        opts = {},
    },
    -- auto pairs
    {
        "echasnovski/mini.pairs",
        lazy = true,
        event = "VeryLazy",
        opts = {
            modes = { insert = true, command = true, terminal = false },
            -- skip autopair when next character is one of these
            skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
            -- skip autopair when the cursor is inside these treesitter nodes
            skip_ts = { "string" },
            -- skip autopair when next character is closing pair
            -- and there are more closing pairs than opening pairs
            skip_unbalanced = true,
            -- better deal with markdown code blocks
            markdown = true,
        },
        config = function(_, opts) Editor.mini.pairs(opts) end,
    },
    -- mini surround
    {
        "echasnovski/mini.surround",
        lazy = true,
        event = "VeryLazy",
        opts = {
            mappings = {
                add = "gsa", -- Add surrounding in Normal and Visual modes
                delete = "gsd", -- Delete surrounding
                find = "gsf", -- Find surrounding (to the right)
                find_left = "gsF", -- Find surrounding (to the left)
                highlight = "gsh", -- Highlight surrounding
                replace = "gsr", -- Replace surrounding
                update_n_lines = "gsn", -- Update `n_lines`
            },
            silent = true,
        },
    },
    {
        "tpope/vim-sleuth",
        lazy = true,
        event = "VeryLazy",
    },
    -- TODO: 这个应该可以移到 lang/lua.lua
    -- lazydev
    {
        "saghen/blink.cmp",
        optional = true,
        opts = {
            sources = {
                -- add lazydev to your completion providers
                default = { "lazydev" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100, -- show at a higher priority than lsp
                    },
                },
            },
        },
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",
        dependencies = {
            { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
        },
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "luvit-meta/library", words = { "vim%.uv" } },
                { path = "snacks.nvim", words = { "Snacks" } },
                { path = "lazy.nvim", words = { "Editor" } },
            },
        },
    },
}

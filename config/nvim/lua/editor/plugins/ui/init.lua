Editor.on_very_lazy(function() require("editor.plugins.ui.whitespace").setup() end)

return {
    {
        "stevearc/aerial.nvim",
        lazy = true,
        cmd = "AerialOpen",
        opts = function()
            local icons = vim.deepcopy(Core.config.icons)

            -- HACK: fix lua's weird choice for `Package` for control
            -- structures like if/else/for/etc.
            icons.lua = { Package = icons.Control }

            ---@type table<string, string[]>|false
            local filter_kind = false
            if Core.config.kind_filter then
                filter_kind = assert(vim.deepcopy(require("core.config").kind_filter))
                filter_kind._ = filter_kind.default
                filter_kind.default = nil
            end

            local opts = {
                backends = { "lsp", "treesitter", "markdown", "man" },
                show_guides = true,
                layout = {
                    win_opts = {
                        winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
                        signcolumn = "no",
                        statuscolumn = "",
                    },
                    placement = "edge",
                },
                icons = icons,
                filter_kind = filter_kind,
                highlight_on_hover = true,
                -- stylua: ignore
                guides = {
                    mid_item   = "├╴",
                    last_item  = "└╴",
                    nested_top = "│ ",
                    whitespace = "  ",
                },
            }

            return opts
        end,
        -- Optional dependencies
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        keys = {
            { "<leader>ca", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
        },
        config = function(_, opts) require("aerial").setup(opts) end,
    },
    -- icons
    {
        "echasnovski/mini.icons",
        lazy = true,
        opts = {
            file = {
                [".keep"] = { glyph = "󰊢 ", hl = "MiniIconsGrey" },
                ["devcontainer.json"] = { glyph = " ", hl = "MiniIconsAzure" },
            },
            filetype = {
                dotenv = { glyph = " ", hl = "MiniIconsYellow" },
            },
        },
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },
    -- ui components
    { "MunifTanjim/nui.nvim", lazy = true, event = "VeryLazy" },
    -- dashboard
    {
        "folke/snacks.nvim",
        opts = {
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
                        { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
                },
            },
        },
    },
    -- snacks
    {
        "folke/snacks.nvim",
        opts = function()
            Snacks.config.style("notification", {
                -- border = "single",
            })

            Snacks.config.style("notification_history", {
                width = 0.8,
                height = 0.8,
            })
        end,
    },
    -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
    {
        "folke/noice.nvim",
        lazy = true,
        event = "VeryLazy",
        cond = function() return true end,
        opts = {
            cmdline = {
                enabled = true,
                view = "cmdline",
                opts = {},
            },
            notify = { enabled = true },
            popupmenu = { enabled = false },
            lsp = {
                progress = {
                    enabled = false,
                },
                hover = { enabled = true },
                signature = { enabled = true },
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                },
            },
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                        },
                    },
                    view = "mini",
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
            },
        },
        -- stylua: ignore
        keys = {
            { "<leader>sn",  "",                                                                            desc = "+noice" },
            { "<S-Enter>",   function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",                              desc = "Redirect Cmdline" },
            { "<leader>snl", function() require("noice").cmd("last") end,                                   desc = "Noice Last Message" },
            { "<leader>snh", function() require("noice").cmd("history") end,                                desc = "Noice History" },
            { "<leader>sna", function() require("noice").cmd("all") end,                                    desc = "Noice All" },
            { "<leader>snd", function() require("noice").cmd("dismiss") end,                                desc = "Dismiss All" },
            { "<leader>snt", function() require("noice").cmd("pick") end,                                   desc = "Noice Picker (Telescope/FzfLua)" },
            { "<c-f>",       function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,                           expr = true,              desc = "Scroll Forward",  mode = { "i", "n", "s" } },
            { "<c-b>",       function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,                           expr = true,              desc = "Scroll Backward", mode = { "i", "n", "s" } },
        },
        config = function(_, opts)
            -- HACK: noice shows messages from before it was enabled,
            -- but this is not ideal when Lazy is installing plugins,
            -- so clear the messages in this case.
            if vim.o.filetype == "lazy" then vim.cmd [[messages clear]] end
            require("noice").setup(opts)
        end,
    },
    -- catppuccin support for blink
    {
        "catppuccin",
        optional = true,
        opts = {
            integrations = { blink_cmp = true },
        },
    },
}

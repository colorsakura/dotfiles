Editor.on_very_lazy(function() require("editor.plugins.ui.whitespace").setup() end)

return {
    {
        "akinsho/bufferline.nvim",
        lazy = true,
        after = "catppuccin",
        event = "VeryLazy",
        keys = {
            { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
            { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
            { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
            { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
            { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
            { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
            { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
            { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
            { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
            { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
        },
        opts = function()
            local opts = {
                options = {
                    close_command = function(n) Snacks.bufdelete(n) end,
                    right_mouse_command = function(n) Snacks.bufdelete(n) end,
                    diagnostics = "nvim_lsp",
                    always_show_bufferline = false,
                    diagnostics_indicator = function(_, _, diag)
                        local icons = Core.config.icons.diagnostics
                        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
                            .. (diag.warning and icons.Warn .. diag.warning or "")
                        return vim.trim(ret)
                    end,
                    offsets = {
                        {
                            filetype = "neo-tree",
                            text = "Neo-tree",
                            highlight = "Directory",
                            text_align = "left",
                        },
                        {
                            filetype = "snacks_layout_box",
                        },
                    },
                    ---@param opts bufferline.IconFetcherOpts
                    get_element_icon = function(opts) return Core.config.icons.ft[opts.filetype] end,
                },
            }
            opts.highlights = require("catppuccin.groups.integrations.bufferline").get {}

            return opts
        end,
        config = function(_, opts)
            require("bufferline").setup(opts)
            -- Fix bufferline when restoring a session
            vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
                callback = function()
                    vim.schedule(function() pcall(nvim_bufferline) end)
                end,
            })
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        lazy = true,
        event = "VeryLazy",
        init = function()
            vim.g.lualine_laststatus = vim.o.laststatus
            if vim.fn.argc(-1) > 0 then
                -- set an empty statusline till lualine loads
                vim.o.statusline = " "
            else
                -- hide the statusline on the starter page
                vim.o.laststatus = 0
            end
        end,
        opts = function()
            -- PERF: we don't need this lualine require madness 🤷
            local lualine_require = require "lualine_require"
            lualine_require.require = require

            local icons = Core.config.icons

            vim.o.laststatus = vim.g.lualine_laststatus

            local opts = {
                options = {
                    theme = "catppuccin",
                    globalstatus = vim.o.laststatus == 3,
                    disabled_filetypes = {
                        statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
                        winbar = { "dashboard", "alpha", "ministarter", "neo-tree", "snacks_dashboard", "toggleterm" },
                    },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },

                    lualine_c = {
                        {
                            "diff",
                            symbols = {
                                added = icons.git.added,
                                modified = icons.git.modified,
                                removed = icons.git.removed,
                            },
                            source = function()
                                local gitsigns = vim.b.gitsigns_status_dict
                                if gitsigns then
                                    return {
                                        added = gitsigns.added,
                                        modified = gitsigns.changed,
                                        removed = gitsigns.removed,
                                    }
                                end
                            end,
                        },
                        {
                            "diagnostics",
                            symbols = {
                                error = icons.diagnostics.Error,
                                warn = icons.diagnostics.Warn,
                                info = icons.diagnostics.Info,
                                hint = icons.diagnostics.Hint,
                            },
                        },
                    },
                    lualine_x = {
                        Snacks.profiler.status(),
                        {
                            function() return "  " .. require("dap").status() end,
                            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
                            color = function() return { fg = Snacks.util.color "Debug" } end,
                        },
                        {
                            require("lazy.status").updates,
                            cond = require("lazy.status").has_updates,
                            color = function() return { fg = Snacks.util.color "Special" } end,
                        },
                    },
                    lualine_y = {
                        { "location", padding = { left = 0, right = 1 } },
                    },
                    lualine_z = {
                        { "fileformat" },
                        { "encoding", show_bomb = true },
                        { "filetype", icon_only = false, separator = "", padding = { left = 1, right = 0 } },
                    },
                },
                extensions = { "neo-tree", "lazy", "fzf", "quickfix" },
            }

            -- do not add trouble symbols if aerial is enabled
            -- And allow it to be overridden for some buffer types (see autocmds)
            if vim.g.trouble_lualine and Editor.has "trouble.nvim" then
                local trouble = require "trouble"
                local symbols = trouble.statusline {
                    mode = "symbols",
                    groups = {},
                    title = false,
                    filter = { range = true },
                    format = "{kind_icon}{symbol.name:Normal}",
                    hl_group = "lualine_c_normal",
                }
                table.insert(opts.sections.lualine_c, {
                    symbols and symbols.get,
                    cond = function() return vim.b.trouble_lualine ~= false and symbols.has() end,
                })
            end

            return opts
        end,
    },
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
                icons = icons.kinds,
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
            style = "glyph",
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
            Snacks.config.style("notification_history", {
                width = 0.95,
                height = 0.95,
            })
        end,
    },
    -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
    {
        "folke/noice.nvim",
        lazy = true,
        event = "VeryLazy",
        --- @module "noice"
        opts = {
            cmdline = {
                enabled = false,
            },
            messages = {
                enabled = false,
            },
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
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
        keys = {
            {
                "<leader>sn",
                "",
                desc = "+noice",
            },
            {
                "<S-Enter>",
                function() require("noice").redirect(vim.fn.getcmdline()) end,
                mode = "c",
                desc = "Redirect Cmdline",
            },
            {
                "<leader>snl",
                function() require("noice").cmd "last" end,
                desc = "Noice Last Message",
            },
            {
                "<leader>snh",
                function() require("noice").cmd "history" end,
                desc = "Noice History",
            },
            {
                "<leader>sna",
                function() require("noice").cmd "all" end,
                desc = "Noice All",
            },
            {
                "<leader>snd",
                function() require("noice").cmd "dismiss" end,
                desc = "Dismiss All",
            },
            {
                "<leader>snt",
                function() require("noice").cmd "pick" end,
                desc = "Noice Picker (Telescope/FzfLua)",
            },
            {
                "<c-f>",
                function()
                    if not require("noice.lsp").scroll(4) then return "<c-f>" end
                end,
                silent = true,
                expr = true,
                desc = "Scroll Forward",
                mode = { "i", "n", "s" },
            },
            {
                "<c-b>",
                function()
                    if not require("noice.lsp").scroll(-4) then return "<c-b>" end
                end,
                silent = true,
                expr = true,
                desc = "Scroll Backward",
                mode = { "i", "n", "s" },
            },
        },
        config = function(_, opts)
            if vim.o.filetype == "lazy" then vim.cmd [[messages clear]] end
            require("noice").setup(opts)
        end,
    },
}

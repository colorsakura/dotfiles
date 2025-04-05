return {
    -- file explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        cmd = "Neotree",
        keys = {
            {
                "<A-m>",
                function() require("neo-tree.command").execute { toggle = true, dir = vim.uv.cwd() } end,
                desc = "Explorer(cwd)",
                remap = true,
            },
            {
                "<leader>e",
                function() require("neo-tree.command").execute { toggle = true, dir = vim.uv.cwd() } end,
                desc = "Explorer(cwd)",
                remap = true,
            },
            {
                "<leader>E",
                function() require("neo-tree.command").execute { toggle = true, dir = Editor.root() } end,
                desc = "Explorer(root)",
                remap = true,
            },
            {
                "<leader>ge",
                function() require("neo-tree.command").execute { source = "git_status", toggle = true } end,
                desc = "Git Explorer",
            },
            {
                "<leader>be",
                function() require("neo-tree.command").execute { source = "buffers", toggle = true } end,
                desc = "Buffer Explorer",
            },
        },
        deactivate = function() vim.cmd [[Neotree close]] end,
        init = function()
            -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
            -- because `cwd` is not set up properly.
            vim.api.nvim_create_autocmd("BufEnter", {
                group = vim.api.nvim_create_augroup("editor.neotree.start_directory", { clear = true }),
                desc = "Start Neo-tree with directory",
                once = true,
                callback = function()
                    if package.loaded["neo-tree"] then
                        return
                    else
                        local stats = vim.uv.fs_stat(vim.fn.argv(0))
                        if stats and stats.type == "directory" then require "neo-tree" end
                    end
                end,
            })
        end,
        opts = {
            use_popups_for_input = true, -- If false, inputs will use vim.ui.input() instead of custom floats.
            sources = { "filesystem", "buffers", "git_status" },
            open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = true,
                    hide_hidden = true, -- only works on Windows
                    -- copy from vscode
                    hide_by_pattern = {
                        "**/.git",
                        "**/.svn",
                        "**/.hg",
                        "**/CVS",
                        "**/.DS_Store",
                        "**/Thumbs.db",
                    },
                },
                bind_to_cwd = false,
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
            },
            window = {
                width = 30,
                mappings = {
                    ["l"] = "open",
                    ["h"] = "close_node",
                    ["<space>"] = "none",
                    ["Y"] = {
                        function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            vim.fn.setreg("+", path, "c")
                        end,
                        desc = "Copy Path to Clipboard",
                    },
                    ["O"] = {
                        function(state) require("lazy.util").open(state.tree:get_node().path, { system = true }) end,
                        desc = "Open with System Application",
                    },
                    ["P"] = { "toggle_preview", config = { use_float = false } },
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
                git_status = {
                    symbols = {
                        unstaged = "󰄱",
                        staged = "󰱒",
                    },
                },
            },
        },
        config = function(_, opts)
            local function on_move(data) Snacks.rename.on_rename_file(data.source, data.destination) end

            local events = require "neo-tree.events"
            opts.event_handlers = opts.event_handlers or {}
            vim.list_extend(opts.event_handlers, {
                { event = events.FILE_MOVED, handler = on_move },
                { event = events.FILE_RENAMED, handler = on_move },
            })
            require("neo-tree").setup(opts)
            vim.api.nvim_create_autocmd("TermClose", {
                pattern = "*lazygit",
                callback = function()
                    if package.loaded["neo-tree.sources.git_status"] then
                        require("neo-tree.sources.git_status").refresh()
                    end
                end,
            })
        end,
    },
    -- search/replace in multiple files
    {
        "MagicDuck/grug-far.nvim",
        opts = { headerMaxWidth = 80 },
        cmd = "GrugFar",
        keys = {
            {
                "<leader>ss",
                function()
                    local grug = require "grug-far"
                    local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
                    grug.open {
                        transient = true,
                        prefills = {
                            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                        },
                        windowCreationCommand = "botright split",
                    }
                end,
                mode = { "n", "v" },
                desc = "Search and Replace",
            },
        },
    },
    -- Flash enhances the built-in search functionality by showing labels
    -- at the end of each match, letting you quickly jump to a specific
    -- location.
    {
        "folke/flash.nvim",
        lazy = true,
        event = { "VeryLazy" },
        ---@type Flash.Config
        opts = {},
        keys = {
            { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            {
                "F",
                mode = { "n", "o", "x" },
                function() require("flash").treesitter() end,
                desc = "Flash Treesitter",
            },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            {
                "R",
                mode = { "o", "x" },
                function() require("flash").treesitter_search() end,
                desc = "Treesitter Search",
            },
            {
                "<c-f>",
                mode = { "c" },
                function() require("flash").toggle() end,
                desc = "Toggle Flash Search",
            },
        },
    },
    -- which-key helps you remember key bindings by showing a popup
    -- with the active keybindings of the command you started typing.
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts_extend = { "spec" },
        opts = function()
            return {
                preset = "helix",
                win = {
                    border = "none" or vim.g.winborder,
                },
                spec = {
                    {
                        mode = { "n", "v" },
                        { "<leader><tab>", group = "tabs" },
                        { "<leader>a", group = "ai" },
                        { "<leader>c", group = "code" },
                        { "<leader>f", group = "file/find" },
                        { "<leader>g", group = "git" },
                        { "<leader>gh", group = "hunks" },
                        { "<leader>o", group = "runner" },
                        { "<leader>q", group = "quit/session" },
                        { "<leader>s", group = "search" },
                        { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
                        { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
                        { "[", group = "prev" },
                        { "]", group = "next" },
                        { "g", group = "goto" },
                        { "gs", group = "surround" },
                        { "z", group = "fold" },
                        {
                            "<leader>b",
                            group = "buffer",
                            expand = function() return require("which-key.extras").expand.buf() end,
                        },
                        {
                            "<leader>w",
                            group = "windows",
                            proxy = "<c-w>",
                            expand = function() return require("which-key.extras").expand.win() end,
                        },
                        -- better descriptions
                        { "gx", desc = "Open with system app" },
                    },
                },
            }
        end,
        keys = {
            {
                "<leader>?",
                function() require("which-key").show { global = false } end,
                desc = "Buffer Keymaps (which-key)",
            },
            {
                "<c-w><space>",
                function() require("which-key").show { keys = "<c-w>", loop = true } end,
                desc = "Window Hydra Mode (which-key)",
            },
        },
        config = function(_, opts)
            local wk = require "which-key"
            wk.setup(opts)
        end,
    },
    -- git signs highlights text that has changed since the list
    -- git commit, and also lets you interactively stage & unstage
    -- hunks in a commit.
    {
        "lewis6991/gitsigns.nvim",
        lazy = true,
        event = "LazyFile",
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            signs_staged = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
            },
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc }) end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
            end,
        },
    },
    {
        "gitsigns.nvim",
        opts = function()
            Snacks.toggle({
                name = "Git Signs",
                get = function() return require("gitsigns.config").config.signcolumn end,
                set = function(state) require("gitsigns").toggle_signs(state) end,
            }):map "<leader>uG"
        end,
    },
    -- better diagnostics list and others
    {
        "folke/trouble.nvim",
        lazy = true,
        cmd = { "Trouble" },
        opts = {
            modes = {
                lsp = {
                    win = { position = "right" },
                },
            },
        },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
            { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
            {
                "<leader>cS",
                "<cmd>Trouble lsp toggle<cr>",
                desc = "LSP references/definitions/... (Trouble)",
            },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
            {
                "[q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").prev { skip_groups = true, jump = true }
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then vim.notify(err, vim.log.levels.ERROR) end
                    end
                end,
                desc = "Previous Trouble/Quickfix Item",
            },
            {
                "]q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").next { skip_groups = true, jump = true }
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then vim.notify(err, vim.log.levels.ERROR) end
                    end
                end,
                desc = "Next Trouble/Quickfix Item",
            },
        },
    },
    -- 终端
    {
        "akinsho/toggleterm.nvim",
        lazy = true,
        event = { "VeryLazy" },
        keys = {
            { "<C-`>", "<cmd>ToggleTerm<cr>", desc = "Open Terminal" },
            { "<A-t>", "<cmd>ToggleTerm<cr>", desc = "Open Terminal" },
        },
        opts = {
            -- size can be a number or function which is passed the current terminal
            size = function(term)
                if term.direction == "horizontal" then
                    return vim.o.lines * 0.3
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            open_mapping = { [[<C-`>]], [[<A-t>]] },
        },
        config = function(_, opts) require("toggleterm").setup(opts) end,
    },
    -- Finds and lists all of the TODO, HACK, BUG, etc comment
    -- in your project and loads them into a browsable list.
    {
        "folke/todo-comments.nvim",
        lazy = true,
        cmd = { "TodoTrouble", "TodoFzfLua" },
        opts = {
            highlight = {
                exclude = { "txt", "bigfile" },
            },
        },
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
            {
                "[t",
                function() require("todo-comments").jump_prev() end,
                desc = "Previous Todo Comment",
            },
            { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
            {
                "<leader>xT",
                "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
                desc = "Todo/Fix/Fixme (Trouble)",
            },
        },
        config = function(_, opts) require("todo-comments").setup(opts) end,
    },
    -- quickfix
    {
        "stevearc/quicker.nvim",
        lazy = true,
        ft = { "qf" },
        opts = {},
        config = function(_, opts) require("quicker").setup(opts) end,
    },
    -- BUG: 需要去除 nvim-treesitter 依赖
    -- see https://github.com/kevinhwang91/nvim-bqf/pull/151
    {
        "kevinhwang91/nvim-bqf",
        lazy = true,
        ft = { "qf" },
        cond = false,
        opts = {
            preview = {
                auto_preview = false,
            },
        },
        config = function(_, opts) require("bqf").setup(opts) end,
    },
    -- diffview
    {
        "sindrets/diffview.nvim",
        lazy = true,
        cmd = { "DiffviewOpen" },
        opts = {},
        config = function(_, opts) require("diffview").setup(opts) end,
    },
    { import = "editor.plugins.extras.editor.fzf" },
    { import = "editor.plugins.extras.editor.runner" },
}

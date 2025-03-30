return {
    {
        "ibhagwan/fzf-lua",
        cmd = { "FzfLua" },
        ---@return table
        opts = function()
            local fzf = require "fzf-lua"
            local actions = fzf.actions
            local config = fzf.config

            -- Quickfix
            config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
            config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
            config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
            config.defaults.keymap.fzf["ctrl-x"] = "jump"
            config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
            config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
            config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
            config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

            return {
                "default-title",
                fzf_color = true,
                fzf_opts = {
                    ["--no-scrollbar"] = true,
                },
                defaults = {
                    formatter = "path.filename_first",
                    -- formatter = "path.dirname_first",
                },
                previewers = {},
                winopts = {
                    winborder = vim.g.winborder or "single",
                    width = 0.95,
                    height = 0.95,
                    row = 0.5,
                    col = 0.5,
                    preview = {
                        border = "single",
                        scrollchars = { "┃", "" },
                    },
                    treesitter = {
                        enabled = true,
                    },
                },
                ui_select = function(fzf_opts, items)
                    return vim.tbl_deep_extend("force", fzf_opts, {
                        prompt = " ",
                        winopts = {
                            title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
                            title_pos = "center",
                        },
                    }, fzf_opts.kind == "codeaction" and {
                        winopts = {
                            layout = "vertical",
                            -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
                            height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
                            width = 0.5,
                            preview = not vim.tbl_isempty(Editor.lsp.get_clients { bufnr = 0, name = "vtsls" }) and {
                                layout = "vertical",
                                vertical = "down:15,border-top",
                                hidden = "hidden",
                            } or {
                                layout = "vertical",
                                vertical = "down:15,border-top",
                            },
                        },
                    } or {
                        winopts = {
                            width = 0.5,
                            -- height is number of items, with a max of 80% screen height
                            height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
                        },
                    })
                end,
                -- pickers
                buffers = {
                    prompt = "  ",
                },
                files = {
                    cmd = "fd",
                    cwd_prompt = false,
                    prompt = "  ",
                    actions = {
                        ["alt-i"] = { actions.toggle_ignore },
                        ["alt-h"] = { actions.toggle_hidden },
                    },
                },
                grep = {
                    actions = {
                        ["alt-i"] = { actions.toggle_ignore },
                        ["alt-h"] = { actions.toggle_hidden },
                    },
                },
            }
        end,
        keys = {
            { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
            { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
            -- find
            { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files" },
            { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Find Buffers" },
            { "<leader>f/", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },
            -- git
            { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Commits" },
            { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Status" },
            -- search
            { "<leader>sr", "<cmd>FzfLua registers<cr>", desc = "Registers" },
            { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
            { "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>", desc = "Buffer Lines" },
            { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
            { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
            { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
            { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
            { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
            { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
            { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
            { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
            { "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
            { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
            { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
            { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
            { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
            { "<leader>st", "<cmd>FzfLua tags<cr>", desc = "Ctags" },
        },
        init = function()
            Editor.on_very_lazy(function()
                ---@diagnostic disable-next-line: duplicate-set-field
                vim.ui.select = function(...)
                    require("lazy").load { plugins = { "fzf-lua" } }
                    local opts = Editor.opts "fzf-lua" or {}
                    require("fzf-lua").register_ui_select(opts.ui_select or {})
                    return vim.ui.select(...)
                end
            end)
        end,
        config = function(_, opts) require("fzf-lua").setup(opts) end,
    },
}

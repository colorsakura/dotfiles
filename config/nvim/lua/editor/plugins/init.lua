return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        version = "*",
        lazy = false,
        opts = function()
            Snacks.toggle.indent():map "<leader>ui"
            Snacks.toggle.animate():map "<leader>ua"
            Snacks.toggle.zen():map "<leader>uz"
            Snacks.toggle.inlay_hints():map "<leader>uh"

            vim.api.nvim_create_autocmd("LspProgress", {
                ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
                callback = function(ev)
                    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

                    Snacks.notifier.notify(vim.lsp.status(), "info", {
                        id = "lsp_progress",
                        title = "LSP Progress",
                        opts = function(notif)
                            notif.icon = ev.data.params.value.kind == "end" and " "
                                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
                        end,
                    })
                end,
            })

            ---@type snacks.Config
            return {
                bigfile = {
                    setup = function(ctx)
                        if vim.fn.exists ":NoMatchParen" ~= 0 then vim.cmd [[NoMatchParen]] end
                        Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
                        vim.b.completion = false -- disable completion
                        vim.b.minianimate_disable = true
                        vim.b[ctx.buf].minidiff_disable = true -- disable minidiff
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
                scroll = { enabled = true },
                stakuscolumn = { enabled = true },
                words = { enabled = true },
            }
        end,
        keys = {
            { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
            { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
            { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
            { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
            { "<leader>gl", function() Snacks.lazygit() end, desc = "Lazygit" },
        },
        config = function(_, opts)
            require("snacks").setup(opts)
            vim.notify = Snacks.notifier
        end,
    },
}

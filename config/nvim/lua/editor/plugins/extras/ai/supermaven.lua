return {
    -- NOTE: AI 为cmp提供的补全代码并不完整, 因此使用inline completion 代替
    {
        "supermaven-inc/supermaven-nvim",
        lazy = true,
        event = "InsertEnter",
        cmd = { "SupermavenUseFree" },
        cond = function() return vim.g.ai == "supermaven" or false end,
        opts = function()
            vim.api.nvim_create_autocmd({ "FileType" }, {
                pattern = "gitcommit",
                callback = function(ev)
                    local _summarize_commit = function()
                        -- local win = vim.api.nvim_get_current_win()
                        local buf = vim.api.nvim_get_current_buf()
                        local output = vim.fn.systemlist "git diff --cached"

                        if #output > 1000 then return end
                        vim.notify "Summarizing commit message..."

                        local prompt =
                            " Give me commit message from git diff output below using conventional commits format."
                        vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "# " .. prompt })

                        for _, line in ipairs(output) do
                            vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "# " .. line })
                        end
                    end
                    _summarize_commit()
                end,
            })
            return {
                keymaps = {
                    -- accept_suggestion = "<C-Enter>",
                    accept_suggestion = "<A-l>",
                    clear_suggestion = "<C-l>",
                },
                ignore_filetypes = { "bigfile", "markdown", "yaml", "toml", "neo-tree-popup" },
                disable_inline_completion = false,
            }
        end,
        config = function(_, opts) require("supermaven-nvim").setup(opts) end,
    },
    {
        "folke/noice.nvim",
        optional = true,
        opts = function(_, opts)
            vim.list_extend(opts.routes, {
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "Starting Supermaven" },
                            { find = "Supermaven Free Tier" },
                        },
                    },
                    skip = true,
                },
            })
        end,
    },
}

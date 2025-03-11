return {
    -- NOTE: AI 为cmp提供的补全代码并不完整, 因此使用inline completion 代替
    {
        "supermaven-inc/supermaven-nvim",
        lazy = true,
        event = "InsertEnter",
        cmd = { "SupermavenUseFree" },
        cond = function() return vim.g.ai == "supermaven" or false end,
        opts = function()
            return {
                keymaps = {
                    accept_suggestion = "<C-Enter>",
                    clear_suggestion = "<C-l>",
                },
                ignore_filetypes = { "bigfile" },
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

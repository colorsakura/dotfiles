return {
    -- Formatter
    {
        "stevearc/conform.nvim",
        cmd = { "ConformInfo" },
        lazy = true,
        keys = {
            { "grf", function() require("conform").format() end },
        },
        opts = function()
            return {
                default_format_opts = {
                    timeout_ms = 1000,
                    async = true,
                    quiet = false,
                    lsp_format = "fallback",
                },
                formatters_by_ft = {
                    c = { "clang_format" },
                    fish = { "fish_indent" },
                    go = { "gofmt", "goimports" },
                    html = { "djlint" },
                    json = { "prettierd", "prettier" },
                    jsonc = { "prettierd", "prettier" },
                    lua = { "stylua" },
                    markdown = { "prettierd", "prettier", "autocorrect" },
                    python = { "ruff", "isort", "black" },
                    rust = { "rustfmt" },
                    sh = { "shfmt" },
                    yaml = { "prettierd", "prettier" },
                },
            }
        end,
        config = function(_, opts)
            vim.tbl_extend("keep", opts, Editor.opts "conform.nvim")
            require("conform").setup(opts)
        end,
    },
}

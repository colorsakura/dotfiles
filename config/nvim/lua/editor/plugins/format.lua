return {
    -- Formatter
    {
        "stevearc/conform.nvim",
        dependencies = { "mason.nvim" },
        cmd = { "ConformInfo" },
        lazy = true,
        keys = {
            { "grf", function() require("conform").format() end, mode = { "n", "v" }, desc = "Code Format" },
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
                    zsh = { "shfmt" },
                    yaml = { "prettierd", "prettier" },
                },
                format_on_save = function(bufnr)
                    local disable_filetypes = { c = true, cpp = true }
                    if disable_filetypes[vim.bo[bufnr].filetype] then
                        return nil
                    else
                        return {
                            timeout_ms = 1000,
                            lsp_format = "fallback",
                        }
                    end
                end,
            }
        end,
        config = function(_, opts)
            vim.tbl_extend("keep", opts, Editor.opts "conform.nvim")
            require("conform").setup(opts)
        end,
    },
}

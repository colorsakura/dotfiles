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
                    gitcommit = { "autocorrect" },
                    html = { "djlint" },
                    json = { "prettierd", "prettier" },
                    jsonc = { "prettierd", "prettier" },
                    lua = { "stylua" },
                    markdown = { "prettierd", "prettier", "autocorrect" },
                    python = { "ruff", "isort", "black" },
                    rust = { "rustfmt" },
                    sh = { "shfmt" },
                    xml = { "xmlformat" },
                    yaml = { "prettierd", "prettier" },
                    zsh = { "shfmt" },
                },
                format_on_save = function(bufnr)
                    local enable_filetypes = { zig = true, markdown = true, go = true, python = true }
                    if enable_filetypes[vim.bo[bufnr].filetype] then
                        return {
                            timeout_ms = 1000,
                            lsp_format = "fallback",
                        }
                    else
                        return nil
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

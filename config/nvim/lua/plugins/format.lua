return {
  -- Formatter
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    event = "LazyFile",
    lazy = true,
    opts = function()
      return {
        default_format_opts = {
          timeout_ms = 3000,
          async = false,
          quiet = false,
          lsp_format = "fallback",
        },
        formatters_by_ft = {
          fish = { "fish_indent" },
          go = { "gofmt", "goimports" },
          lua = { "stylua" },
          markdown = { "prettierd", "prettier" },
          python = { "ruff", "isort", "black" },
          rust = { "rustfmt" },
          sh = { "shfmt" },
        },
      }
    end,
  },
}

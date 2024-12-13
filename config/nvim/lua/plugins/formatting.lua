return {
	-- Formatter
	{
		"stevearc/conform.nvim",
		cmd = { "ConformInfo" },
		dependencies = { "mason.nvim" },
		event = "LazyFile",
		lazy = true,
		opts = {
			default_format_opts = {
				timeout_ms = 3000,
				async = false,       -- not recommended to change
				quiet = false,       -- not recommended to change
				lsp_format = "fallback", -- not recommended to change
			},
			formatters_by_ft = {
				fish = { "fish_indent" },
				lua = { "stylua" },
				sh = { "shfmt" },
				yaml = { "prettier" },
			},
		},
		config = function(_, opts) require("conform").setup { opts } end,
	},
}

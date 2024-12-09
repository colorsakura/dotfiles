return {
	-- Formatter
	{
		"stevearc/conform.nvim",
		lazy = true,
		event = "VeryLazy",
		config = function()
			require("conform").setup {
				formatters_by_ft = {
					c = { "clang-format" },
					lua = { "stylua" },
					rust = { "rustfmt", lsp_format = "fallback" },
					xml = { "xmlformat" },
					python = function(bufnr)
						if require("conform").get_formatter_info("ruff_format", bufnr).available then
							return { "ruff_format" }
						else
							return { "isort", "black" }
						end
					end,
				},
				default_format_opts = {
					lsp_format = "fallback",
				},
			}
		end,
	},
	-- Integrating non-LSPs like Prettier
	{
		"nvimtools/none-ls.nvim",
		lazy = true,
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local nls = require "null-ls"

			nls.setup {
				sources = {
					nls.builtins.formatting.stylua,
				},
			}
		end,
	},
}

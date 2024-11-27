vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(args)
		local buf = args.buf
		local keymap = vim.api.nvim_buf_set_keymap

		keymap(buf, "n", "grf", "<cmd>lua vim.lsp.buf.format()<cr>", { noremap = true })

		vim.diagnostic.config {
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = "󰌵 ",
					[vim.diagnostic.severity.INFO] = "󰋼 ",
					[vim.diagnostic.severity.HINT] = " ",
				},
			},
			virtual_text = true,
			underline = true,
			jump = { float = true },
		}
	end,
})

return {
	-- Lsp config
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"williamboman/mason.nvim",
				build = ":MasonUpdate",
				cmd = { "Mason", "MasonInstall" },
			},
			{
				"williamboman/mason-lspconfig.nvim",
			},
			{ "onsails/lspkind.nvim" },
		},
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
		config = function(_, opts)
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			capabilities.textDocument.completion.completionItem = {
				documentationFormat = { "markdown", "plaintext" },
				snippetSupport = true,
				preselectSupport = true,
				insertReplaceSupport = true,
				labelDetailsSupport = true,
				deprecatedSupport = true,
				commitCharactersSupport = true,
				tagSupport = { valueSet = { 1 } },
				resolveSupport = {
					properties = {
						"documentation",
						"detail",
						"additionalTextEdits",
					},
				},
			}

			require("mason").setup()
			require("mason-lspconfig").setup()

			require("mason-lspconfig").setup_handlers {
				function(server)
					require("lspconfig")[server].setup {
						capabilities = capabilities,
					}
				end,
			}
		end,
	},
	-- Formatter
	{
		"stevearc/conform.nvim",
		event = "VeryLazy",
		config = function()
			require("conform").setup {
				formatters_by_ft = {
					c = { "clang-format" },
					lua = { "stylua" },
					rust = { "rustfmt", lsp_format = "fallback" },
					xml = { "xmlformat" },
					python = function(bufnr)
						if
								require("conform").get_formatter_info("ruff_format", bufnr).available
						then
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
	-- Mason
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		opts = {
			pip = {
				upgrade_pip = true,
			},
			ui = {
				icons = {
					package_installed = "●",
					package_pending = "●",
					package_uninstalled = "○",
				},
				border = vim.g.border or "none",
				width = 0.65,
				height = 0.65,
			},
		},
	},
	-- Neovim dev
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
}

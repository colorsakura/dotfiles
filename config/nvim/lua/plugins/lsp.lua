vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(event)
		vim.diagnostic.config {
			signs = {
				text = {
					-- [vim.diagnostic.severity.ERROR] = " ",
					-- [vim.diagnostic.severity.WARN] = "󰌵 ",
					-- [vim.diagnostic.severity.INFO] = "󰋼 ",
					-- [vim.diagnostic.severity.HINT] = " ",
					[vim.diagnostic.severity.ERROR] = "● ",
					[vim.diagnostic.severity.WARN] = "● ",
					[vim.diagnostic.severity.INFO] = "● ",
					[vim.diagnostic.severity.HINT] = "● ",
				},
			},
			virtual_text = false,
			underline = false,
			jump = { float = true },
		}

		vim.keymap.set(
			"n",
			"K",
			"<cmd>Lspsaga hover_doc<cr>",
			{ buffer = event.buf, desc = "Hover Doc" }
		)
		vim.keymap.set(
			"n",
			"gd",
			vim.lsp.buf.definition,
			{ buffer = event.buf, desc = "Goto Definition" }
		)
		vim.keymap.set(
			"n",
			"gD",
			vim.lsp.buf.declaration,
			{ buffer = event.buf, desc = "Goto Declaration" }
		)
		vim.keymap.set(
			"n",
			"gri",
			vim.lsp.buf.implementation,
			{ buffer = event.buf, desc = "Goto Implementation" }
		)
		vim.keymap.set(
			"n",
			"grr",
			vim.lsp.buf.references,
			{ buffer = event.buf, desc = "Goto References" }
		)
		vim.keymap.set(
			{ "n", "x" },
			"gra",
			vim.lsp.buf.code_action,
			{ buffer = event.buf, desc = "Code Actions" }
		)
		vim.keymap.set(
			"n",
			"grn",
			"<cmd>Lspsaga rename<cr>",
			{ buffer = event.buf, desc = "Code Rename" }
		)
		vim.keymap.set(
			"n",
			"grf",
			vim.lsp.buf.format,
			{ buffer = event.buf, desc = "Format buffer" }
		)
		vim.keymap.set(
			"n",
			"grF",
			"<cmd>Lspsaga finder<cr>",
			{ buffer = event.buf, desc = "Find references and implementation" }
		)
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
			{
				"nvimdev/lspsaga.nvim",
				config = function()
					require("lspsaga").setup {
						ui = {
							winbar_prefix = "",
							border = "rounded",
							devicon = true,
							foldericon = true,
							title = true,
							expand = "⊞",
							collapse = "⊟",
							code_action = "💡",
							lines = { "┗", "┣", "┃", "━", "┏" },
							kind = nil,
							button = { "", "" },
							imp_sign = "󰳛 ",
							use_nerd = true,
						},
						hover = {
							max_width = 0.7,
							max_height = 0.6,
							open_link = "gx",
							open_cmd = "!chrome",
						},
						diagnostic = {
							show_layout = "float",
							show_normal_height = 10,
							jump_num_shortcut = true,
							auto_preview = false,
							max_width = 0.8,
							max_height = 0.6,
							max_show_width = 0.9,
							max_show_height = 0.6,
							wrap_long_lines = true,
							extend_relatedInformation = false,
							diagnostic_only_current = false,
							keys = {
								exec_action = "o",
								quit = "q",
								toggle_or_jump = "<CR>",
								quit_in_show = { "q", "<ESC>" },
							},
						},
						code_action = {
							num_shortcut = true,
							show_server_name = false,
							extend_gitsigns = false,
							only_in_cursor = true,
							max_height = 0.3,
							cursorline = true,
							keys = {
								quit = "q",
								exec = "<CR>",
							},
						},
						lightbulb = {
							enable = true,
							sign = true,
							debounce = 10,
							sign_priority = 40,
							virtual_text = true,
							enable_in_insert = true,
							ignore = {
								clients = {},
								ft = {},
							},
						},
						scroll_preview = {
							scroll_down = "<C-f>",
							scroll_up = "<C-b>",
						},
						request_timeout = 2000,
						finder = {
							max_height = 0.5,
							left_width = 0.4,
							methods = {},
							default = "ref+imp",
							layout = "float",
							silent = false,
							filter = {},
							fname_sub = nil,
							sp_inexist = false,
							sp_global = false,
							ly_botright = false,
							number = vim.o.number,
							relativenumber = vim.o.relativenumber,
							keys = {
								shuttle = "[w",
								toggle_or_open = "o",
								vsplit = "s",
								split = "i",
								tabe = "t",
								tabnew = "r",
								quit = "q",
								close = "<C-c>k",
							},
						},
						definition = {
							width = 0.6,
							height = 0.5,
							save_pos = false,
							number = vim.o.number,
							relativenumber = vim.o.relativenumber,
							keys = {
								edit = "<C-o>",
								vsplit = "<C-v>",
								split = "<C-x>",
								tabe = "<C-t>",
								tabnew = "<C-c>n",
								quit = "q",
								close = "<ESC>",
							},
						},
						rename = {
							in_select = true,
							auto_save = false,
							project_max_width = 0.5,
							project_max_height = 0.5,
							keys = {
								quit = "<C-k>",
								exec = "<CR>",
								select = "x",
							},
						},
						symbol_in_winbar = {
							enable = true,
							separator = " › ",
							hide_keyword = false,
							ignore_patterns = nil,
							show_file = true,
							folder_level = 1,
							color_mode = true,
							delay = 300,
						},
						outline = {
							win_position = "right",
							win_width = 30,
							auto_preview = true,
							detail = true,
							auto_close = true,
							close_after_jump = false,
							layout = "normal",
							max_height = 0.5,
							left_width = 0.3,
							keys = {
								toggle_or_jump = "o",
								quit = "q",
								jump = "e",
							},
						},
						callhierarchy = {
							layout = "float",
							left_width = 0.2,
							keys = {
								edit = "e",
								vsplit = "s",
								split = "i",
								tabe = "t",
								close = "<C-c>k",
								quit = "q",
								shuttle = "[w",
								toggle_or_req = "u",
							},
						},
						typehierarchy = {
							layout = "float",
							left_width = 0.2,
							keys = {
								edit = "e",
								vsplit = "s",
								split = "i",
								tabe = "t",
								close = "<C-c>k",
								quit = "q",
								shuttle = "[w",
								toggle_or_req = "u",
							},
						},
						implement = {
							enable = false,
							sign = true,
							lang = {},
							virtual_text = true,
							priority = 100,
						},
						beacon = {
							enable = true,
							frequency = 7,
						},
						floaterm = {
							height = 0.7,
							width = 0.7,
						},
					}
				end,
			},
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
		-- keys = {
		--   {
		--     "grf",
		--     function() require("conform").format { async = true } end,
		--     mode = { "n" },
		--     desc = "Format buffer",
		--   },
		-- },
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
					-- FIXME: 开启后会降低blink.cmp的使用体验
					-- nls.builtins.completion.spell,
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

return {
	{
		"saghen/blink.cmp",
		lazy = true,
		event = { "InsertEnter" },
		version = "v0.*",
		-- build = "cargo build --release",
		opts_extend = {
			"sources.completion.enabled_providers",
			"sources.compat",
		},
		dependencies = {
			"rafamadriz/friendly-snippets",
			-- add blink.compat to dependencies
			{
				"saghen/blink.compat",
				optional = true, -- make optional so it's only enabled if any extras need it
				opts = {},
				version = "*",
			},
		},
		opts = {
			appearance = {
				-- sets the fallback highlight groups to nvim-cmp's highlight groups
				-- useful for when your theme doesn't support blink.cmp
				-- will be removed in a future release, assuming themes add support
				use_nvim_cmp_as_default = false,
				-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},
			completion = {
				accept = {
					-- experimental auto-brackets support
					auto_brackets = {
						enabled = true,
					},
				},
				menu = {
					draw = {
						treesitter = true,
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				ghost_text = {
					enabled = vim.g.ai_cmp,
				},
			},

			-- experimental signature help support
			-- signature = { enabled = true },

			sources = {
				-- adding any nvim-cmp sources here will enable them
				-- with blink.compat
				compat = {},
				completion = {
					-- remember to enable your providers here
					enabled_providers = { "lsp", "path", "snippets", "buffer" },
				},
			},

			keymap = {
				preset = "enter",
				-- ["<Tab>"] = {
				-- 	Editor.cmp.map { "snippet_forward", "ai_accept" },
				-- 	"fallback",
				-- },
			},

			kind_icons = Editor.config.icons.kinds,
		},
		---@param opts blink.cmp.Config | { sources: { compat: string[] } }
		config = function(_, opts)
			-- setup compat sources
			local enabled = opts.sources.completion.enabled_providers
			for _, source in ipairs(opts.sources.compat or {}) do
				opts.sources.providers[source] = vim.tbl_deep_extend(
					"force",
					{ name = source, module = "blink.compat.source" },
					opts.sources.providers[source] or {}
				)
				if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then table.insert(enabled, source) end
			end

			-- check if we need to override symbol kinds
			for _, provider in pairs(opts.sources.providers or {}) do
				---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
				if provider.kind then
					require("blink.cmp.types").CompletionItemKind[provider.kind] = provider.kind
					---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
					local transform_items = provider.transform_items
					---@param ctx blink.cmp.Context
					---@param items blink.cmp.CompletionItem[]
					provider.transform_items = function(ctx, items)
						items = transform_items and transform_items(ctx, items) or items
						for _, item in ipairs(items) do
							item.kind = provider.kind or item.kind
						end
						return items
					end
				end
			end

			require("blink.cmp").setup(opts)
		end,
	},
	-- Snippets
	-- TODO:
	{
		"blink.nvim",
		optional = true,
		dependencies = {
			"L3MON4D3/LuaSnip",
			event = { "InsertEnter" },
			dependencies = {
				"rafamadriz/friendly-snippets",
			},
			config = function()
				vim.schedule(function() require("luasnip.loaders.from_vscode").lazy_load() end)
				vim.schedule(
					function()
						require("luasnip.loaders.from_vscode").lazy_load {
							paths = "./snippets",
						}
					end
				)
			end,
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
	},
	-- auto pairs
	{
		"echasnovski/mini.pairs",
		lazy = true,
		event = "VeryLazy",
		opts = {
			modes = { insert = true, command = true, terminal = false },
			-- skip autopair when next character is one of these
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			-- skip autopair when the cursor is inside these treesitter nodes
			skip_ts = { "string" },
			-- skip autopair when next character is closing pair
			-- and there are more closing pairs than opening pairs
			skip_unbalanced = true,
			-- better deal with markdown code blocks
			markdown = true,
		},
		config = function(_, opts) Editor.mini.pairs(opts) end,
	},
	-- comments
	{
		"folke/ts-comments.nvim",
		lazy = true,
		event = "VeryLazy",
		opts = {},
	},
	-- Better text-objects
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		opts = function()
			local ai = require "mini.ai"
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter { -- code block
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					},
					f = ai.gen_spec.treesitter { a = "@function.outer", i = "@function.inner" }, -- function
					c = ai.gen_spec.treesitter { a = "@class.outer", i = "@class.inner" },       -- class
					t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },          -- tags
					d = { "%f[%d]%d+" },                                                         -- digits
					e = {                                                                        -- Word with case
						{ "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
						"^().*()$",
					},
					-- i = LazyVim.mini.ai_indent, -- indent
					-- g = LazyVim.mini.ai_buffer, -- buffer
					u = ai.gen_spec.function_call(),                          -- u for "Usage"
					U = ai.gen_spec.function_call { name_pattern = "[%w_]" }, -- without dot in function name
				},
			}
		end,
		config = function(_, opts) require("mini.ai").setup(opts) end,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		cmd = "LazyDev",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "snacks.nvim",        words = { "Snacks" } },
				{ path = "lazy.nvim",          words = { "LazyVim" } },
			},
		},
	},
	-- lazydev
	{
		"saghen/blink.cmp",
		opts = {
			sources = {
				completion = {
					-- add lazydev to your completion providers
					enabled_providers = { "lazydev" },
				},
				providers = {
					lsp = {
						-- dont show LuaLS require statements when lazydev has items
						fallback_for = { "lazydev" },
					},
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
					},
				},
			},
		},
	},
	-- catppuccin support
	{
		"catppuccin",
		optional = true,
		opts = {
			integrations = { blink_cmp = true },
		},
	},
}

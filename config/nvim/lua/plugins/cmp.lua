return {
	-- Snippets
	{
		"L3MON4D3/LuaSnip",
		event = { "InsertEnter" },
		dependencies = {
			"rafamadriz/friendly-snippets",
			config = function()
				vim.schedule(
					function() require("luasnip.loaders.from_vscode").lazy_load() end
				)
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
	{
		"saghen/blink.cmp",
		event = { "InsertEnter" },
		-- optional: provides snippets for the snippet source
		dependencies = {
			{ "rafamadriz/friendly-snippets" },
		},
		version = 'v0.*',
		-- build = "cargo build --release",
		opts = {
			keymap = { preset = "super-tab" },
			sources = {
				-- add lazydev to your completion providers
				completion = {
					enabled_providers = { "lsp", "path", "snippets", "buffer", "lazydev" },
				},
				providers = {
					-- dont show LuaLS require statements when lazydev has items
					lsp = { fallback_for = { "lazydev" } },
					lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
				},
			},
			windows = {
				autocomplete = {
					winblend = vim.o.pumblend,
				},
				documentation = {
					auto_show = true,
				},
				ghost_text = {
					enabled = true,
				},
			},
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},
		},
	},
}

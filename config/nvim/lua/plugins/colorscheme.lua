return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				integrations = {
					barbar = true,
					cmp = true,
					dashboard = true,
					gitsigns = true,
					markdown = true,
					mason = true,
					neotree = true,
					notify = true,
					semantic_tokens = true,
					treesitter = true,
					treesitter_context = true,
					which_key = true,
					indent_blankline = {
						enabled = true,
					},
					telescope = {
						enabled = true,
					},
					native_lsp = {
						enabled = true,
						virtual_text = {
							errors = { "italic" },
							hints = { "italic" },
							warnings = { "italic" },
							information = { "italic" },
						},
						underlines = {
							errors = { "underline" },
							hints = { "underline" },
							warnings = { "underline" },
							information = { "underline" },
						},
						inlay_hints = {
							background = true,
						},
					},
				},
			})
		end,
	},
}

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
					notify = true,
					dashboard = true,
					gitsigns = true,
					mason = true,
					neotree = true,
					semantic_tokens = true,
					treesitter = true,
					telescope = {
						enabled = true,
						-- style = "nvchad",
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
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufNewFIle", "BufReadPre" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua", "python", "zig", "go", "markdown", "markdown_inline", "vim", "vimdoc", "query" },
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = false },
			})
		end,
	},
	{
		'nvim-treesitter/nvim-treesitter-context',
		event = { "BufNewFIle", "BufReadPre" },
		dependencies = 'nvim-treesitter',
		config = true,
	},
	{
		"norcalli/nvim-colorizer.lua",
		event = { "BufNewFIle", "BufReadPre" },
		config = true,
	},
}

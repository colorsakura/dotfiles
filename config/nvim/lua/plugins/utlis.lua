return {
	{
		"akinsho/toggleterm.nvim",
		opts = {
			open_mapping = [[<c-\>]]
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)
		end
	},
	{
		"lilydjwg/fcitx.vim",
	},
	{
		"MeanderingProgrammer/markdown.nvim",
		opts = {
			enabled = false,
		},
		config = function(_, opts) require("render-markdown").setup(opts) end,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		config = function(_, opts) require("nvim-highlight-colors").setup(opts) end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
		},
		keys = {
			{
				"<leader>?",
				function() require("which-key").show { global = false } end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.add(
				{ "<leader>b", group = "Buffer" },
				{ "<leader>t", group = "Telescope" },
				{ "<leader>w", group = "Window" }
			)
			wk.setup(opts)
		end,
	},
	{
		"yianwillis/vimcdoc",
		event = { "VeryLazy" },
		enabled = false,
	},
}

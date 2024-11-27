return {
	{
		"akinsho/toggleterm.nvim",
		lazy = false,
		opts = {
			open_mapping = [[<c-\>]],
		},
		config = function(_, opts) require("toggleterm").setup(opts) end,
	},
	{
		"lilydjwg/fcitx.vim",
		events = "VeryLazy",
	},
}

return {
	{
		"akinsho/toggleterm.nvim",
		lazy = true,
		events = { "VeryLazy" },
		opts = {
			open_mapping = [[<c-\>]],
		},
		config = function(_, opts) require("toggleterm").setup(opts) end,
	},
	{
		"lilydjwg/fcitx.vim",
		lazy = true,
		events = { "LazyFile", "VeryLazy" },
	},
}

return {
	{
		"akinsho/toggleterm.nvim",
		lazy = true,
		events = { "VeryLazy" },
		keys = { { "<c-\\>", "<cmd>ToggleTerm<cr>" } },
		opts = {
			open_mapping = [[<c-\>]],
		},
		config = function(_, opts) require("toggleterm").setup(opts) end,
	},
	-- Sorting plugin that supports line-wise and delimiter sorting
	{
		"sQVe/sort.nvim",
		lazy = true,
		events = { "LazyFile" },
		keys = {
			{ "gos", ":Sort<CR>",      mode = "n", desc = "Sort", silent = true },
			{ "gos", "<Esc>:Sort<CR>", mode = "v", desc = "Sort", silent = true },
		},
	},
}

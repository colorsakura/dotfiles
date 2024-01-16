return {
	{
		"akinsho/toggleterm.nvim",
		opts = {
			persist_mode = true,
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)
		end,
	},
}

return {
	{
		"romgrk/barbar.nvim",
		event = "UIEnter",
		opts = {
			animation = false,
			sidebar_filetypes = {
				['neo-tree'] = { event = 'BufWipeout' },
			},
		},
		config = function(_, opts)
			require("barbar").setup(opts)
		end,
	},
}

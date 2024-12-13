return {
	{
		"OXY2DEV/markview.nvim",
		lazy = true,
		ft = "markdown", -- If you decide to lazy-load anyway
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = function()
			Snacks.toggle({
				name = "Markview",
				get = "<cmd>Markview enable<cr>",
				set = "<cmd>Markview disable<cr>",
			}):map("<leader>uv")
		end
	}
}

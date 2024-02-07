return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = "VeryLazy",
		opts = {},
		config = function()
			require("ibl").setup({
				exclude = {
					filetypes = { "dashboard", },
				},
			})
		end,
	},
	{
		'NMAC427/guess-indent.nvim',
		event = 'BufReadPre',
		opts = function(_, o)
			o.auto_cmd = true
			o.override_editorconfig = false
		end,
	},

}

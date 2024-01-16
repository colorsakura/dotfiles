return {
	"nvimdev/lspsaga.nvim",
	config = function(_, opts)
		require('lspsaga').setup(opts, {
			ui = {
			},
			lightbulb = {
				virtual_text = false,
			},
		})
	end,
}

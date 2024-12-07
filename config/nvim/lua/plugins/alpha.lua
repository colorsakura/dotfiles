return {
	-- Dashboard
	{
		"goolord/alpha-nvim",
		event = { "BufEnter" },
		dependencies = {
			"echasnovski/mini.icons",
			{ "nvim-tree/nvim-web-devicons" },
		},
		config = function()
			local dashboard = require "alpha.themes.dashboard"
			require("alpha").setup(dashboard.config)
		end,
	},
}

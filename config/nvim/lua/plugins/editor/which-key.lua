return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
		plugins = {
			spelling = { enabled = true }
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.register(mappings, opts)
	end,
}

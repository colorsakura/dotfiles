return {
	"nvim-telescope/telescope.nvim",
	version = false,
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-fzf-native.nvim",
	},
	opts = function()
		local actions = require("telescope.actions")
		return {
			defaults = {
				layout_configs = {},
				mappings = {
					i = {
						["<esc>"] = actions.close
					},
				},
			},
		}
	end,
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		-- telescope.load_extension 'fzf'
	end
}

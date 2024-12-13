return {
	{
		"ibhagwan/fzf-lua",
		lazy = true,
		events = "VeryLazy",
		opts = function()

		end,
		config = function()
			require("fzf-lua").setup({})
		end,
		keys = {
			{ "<leader>f", require("fzf-lua").files }
		}
	}
}

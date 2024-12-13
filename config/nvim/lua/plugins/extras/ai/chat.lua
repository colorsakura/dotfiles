return {
	{
		"olimorris/codecompanion.nvim",
		lazy = true,
		cmd = { "CodeCompanionChat" },
		events = "BufEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("codecompanion").setup {
				strategies = {
					chat = {
						adapter = "gemini",
					},
				},

				adapters = {
					gemini = function()
						return require("codecompanion.adapters").extend("gemini", {
							env = { api_key = "GOOGLE_AI_API_KEY" },
						})
					end,
				},
			}
		end,
	},
}

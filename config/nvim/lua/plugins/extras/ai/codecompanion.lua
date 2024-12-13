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
					inline = {
						adapter = "gemini"
					}
				},

				adapters = {
					gemini = function()
						return require("codecompanion.adapters").extend("gemini", {
							env = { api_key = "GOOGLE_AI_API_KEY" },
							model = "gemini-2.0-flash-exp"
						})
					end,
				},
			}
		end,
	},
	-- {
	-- 	"saghen/blink.cmp",
	-- 	optional = true,
	-- 	dependencies = { "olimorris/codecompanion.nvim" },
	-- 	opts = {
	-- 		sources = {
	-- 			default = { "codecompanion" },
	-- 			providers = {
	-- 				codecompanion = {
	-- 					name = "CodeCompanion",
	-- 					kind = "Supermaven",
	-- 					module = "codecompanion.providers.completion.blink",
	-- 					enabled = true,
	-- 				},
	-- 			},
	-- 		},
	-- 	}
	-- }
}

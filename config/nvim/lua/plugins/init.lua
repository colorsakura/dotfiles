require("config").init()

return {
	{ "folke/lazy.nvim", version = "*" },
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = function()
			return {
				animate = { enabled = true },
				bigfile = { enabled = true },
				debug = { enabled = true },
				indent = { enabled = true },
				notifier = { enabled = true },
				quickfile = { enabled = true },
				scope = { enabled = true },
				words = { enabled = true },
			}
		end,
		-- stylua: ignore
		keys = {
			{ "<leader>.",  function() Snacks.scratch() end,               desc = "Toggle Scratch Buffer" },
			{ "<leader>S",  function() Snacks.scratch.select() end,        desc = "Select Scratch Buffer" },
			{ "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
			{ "<leader>un", function() Snacks.notifier.hide() end,         desc = "Dismiss All Notifications" },
		},
		config = function(_, opts) require("snacks").setup(opts) end,
	},
}

return {
	{
		"numToStr/Comment.nvim",
		event = { "BufNewFIle", "BufReadPre" },
		config = function()
			require('Comment').setup()
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "plenary.nvim" },
		event = { "BufNewFIle", "BufReadPre" },
		config = function()
			require("todo-comments").setup()
		end,
	}
}

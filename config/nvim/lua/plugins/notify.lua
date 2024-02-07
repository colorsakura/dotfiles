return {
	-- TODO: notify why?
	"rcarriga/nvim-notify",
	event = "VeryLazy",
	config = function()
		vim.notify = require("notify")
	end,
}

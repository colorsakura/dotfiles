return {
	"rcarriga/nvim-notify",
	event = "UIEnter",
	opts = {
		stages = "fade_in_slide_out",
	},
	config = function(_, opts)
		local notify = require("notify")
		notify.setup(opts)
		vim.notify = notify
	end,
}

return {
	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		event = { "VeryLazy" },
		opts = {
			options = {
				theme = vim.g.theme or "onedark",
				component_separators = "|",
				section_separators = {},
				globalstatus = true,
				disabled_filetypes = {
					statusline = { "alpha", "lazy", "mason" },
					winbar = {},
				},
				ignore_focus = {
					"dapui_watches",
					"dapui_stacks",
					"dapui_breakpoints",
					"dapui_scopes",
					"dapui_console",
					"dap-repl",
				},
			},
			-- +-------------------------------------------------+
			-- | A | B | C                             X | Y | Z |
			-- +-------------------------------------------------+
			sections = {
				lualine_a = {
					{ "mode", separator = { left = "" }, right_padding = 2 },
				},
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = {
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = {
					{
						function()
							local loc = require "lualine.components.location" ()
							local sel = require "lualine.components.selectioncount" ()
							if sel ~= "" then loc = loc .. " (" .. sel .. " sel)" end
							return loc
						end,
						separator = { right = "" },
						left_padding = 2,
					},
				},
			},
		},
	},
}

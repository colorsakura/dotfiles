return {
	{
		"nvimdev/guard.nvim",
		-- Builtin configuration, optional
		dependencies = {
			"nvimdev/guard-collection",
		},
		config = function()
			local ft = require("guard.filetype")

			-- use clang-format and clang-tidy for C files
			ft("c"):fmt("clang-format")

			-- use stylua to format lua files and no linter
			ft("lua"):fmt("lsp"):append("stylua"):lint("selene")

			-- use lsp to format first then use golines to format
			ft("go"):fmt("lsp"):append("golines")

			ft("python"):fmt("ruff"):lint("ruff")

			require("guard").setup({
				-- the only options for the setup function
				fmt_on_save = false,
				-- Use lsp if no formatter was defined for this filetype
				lsp_as_default_formatter = false,
			})
		end,
	},
}

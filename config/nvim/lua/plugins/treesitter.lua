return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufNewFIle", "BufReadPre" },
		cond = not vim.g.vscode,
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = false },
			})
		end,
	},
	{
		'nvim-treesitter/nvim-treesitter-context',
		event = { "BufNewFIle", "BufReadPre" },
		dependencies = 'nvim-treesitter',
		config = true,
	},
	{
		"norcalli/nvim-colorizer.lua",
		event = { "BufNewFIle", "BufReadPre" },
		config = true,
	},
}

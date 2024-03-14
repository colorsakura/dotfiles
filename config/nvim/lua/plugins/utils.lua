return {
	-- 编辑大文件优化
	{
		'LunarVim/bigfile.nvim',
		event = 'BufReadPre',
		config = true,
	},
	-- 自动切换输入法
	{ "lilydjwg/fcitx.vim", event = { "BufReadPre", "BufNewFile", "InsertEnter" }, },
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		filetype = { "markdown" },
		event = { "BufNewFile", "BufReadPre" },
	},
	-- apple pkl
	{
		"apple/pkl-neovim",
		event = "BufReadPre *.pkl",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		build = function()
			vim.cmd("TSInstall! pkl")
		end,
	},
	{
		"lukas-reineke/virt-column.nvim",
		event = { "BufReadPre" },
		opts = {
			char = "▏",
			virtcolumn = "+1, 80, 120",
		},
	}
}

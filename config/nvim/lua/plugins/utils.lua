return {
				-- 编辑大文件优化
	{ 'LunarVim/bigfile.nvim', config = true, event = 'BufReadPre' },
	{ "lilydjwg/fcitx.vim", event = { "BufReadPre", "BufNewFile", "InsertEnter" }, }
}

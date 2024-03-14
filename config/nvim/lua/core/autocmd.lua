local function augroup(name)
	return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"checkhealth",
		"help",
		"lspinfo",
		"man",
		"neotest-output",
		"neotest-output-panel",
		"neotest-summary",
		"notify",
		"qf",
		"query",
		"spectre_panel",
		"startuptime",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Filetype specific
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("set_go_indent"),
	pattern = "go",
	desc = "Set indent for go",
	callback = function()
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.expandtab = false
	end,
})

vim.api.nvim_create_autocmd({
	"FocusGained",
	"BufEnter",
	"CursorHold",
}, {
	group = augroup("buffer_reload"),
	desc = "Reload buffer on focus",
	callback = function()
		if vim.fn.getcmdwintype() == "" then
			vim.cmd "checktime"
		end
	end,
})

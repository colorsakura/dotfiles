local M = {}

function M.setup()
	if Editor.is_loaded "conform.nvim" then vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end
end

return M

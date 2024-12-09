-- TODO: Neovim 的 health 似乎不支持当前配置的目录结构
local M = {}

local start = vim.health.start
local ok = vim.health.ok
local warn = vim.health.warn
local error = vim.health.error

function M.check()
	start "Editor"

	if vim.fn.has "nvim-0.10.0" == 1 then
		ok "Using Neovim >= 0.10.0"
	else
		warn "Use Neovim >= 0.10.0 for the best experience"
	end
end

return M

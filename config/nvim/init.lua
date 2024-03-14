if vim.loader and vim.fn.has "nvim-0.9.1" == 1 then vim.loader.enable() end

for _, source in pairs {
	"core.options",
	"core.lazy",
	"core.autocmd",
	"core.keymaps",
} do
	local ok, fault = pcall(require, source)
	if not ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

if not pcall(vim.cmd.colorscheme, "catppuccin") then
	vim.notify("Failed to load catppuccin colorscheme.")
end

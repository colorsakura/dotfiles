if vim.loader then vim.loader.enable() end

local ok, core = pcall(require, "core")
if ok then core.setup() end

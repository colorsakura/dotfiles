if vim.loader then vim.loader.enable() end

require("core").setup()

local ok, editor = pcall(require, "editor")
if ok then
  editor.setup()
else
  vim.notify("Failed to load editor", vim.log.levels.ERROR)
end

local M = {}

function M.setup() end

function M.formatexpr()
  if Editor.has "conform.nvim" then return require("conform").formatexpr() end
  return vim.lsp.formatexpr { timeout_ms = 3000 }
end

return M

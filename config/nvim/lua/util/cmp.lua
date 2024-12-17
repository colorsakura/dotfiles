local M = {}

function M.snippet_stop()
  if vim.snippet then vim.snippet.stop() end
end

return M

local M = {}

function M.filename()
  return {
    init = function(self) self.filename = vim.api.nvim_buf_get_name(0) end,
    provider = function(self)
      -- first, trim the pattern relative to the current directory. For other
      -- options, see :h filename-modifers
      local filename = vim.fn.fnamemodify(self.filename, ":.")
      if filename == "" then return "[No Name]" end
      -- now, if the filename would occupy more than 1/4th of the available
      -- space, we trim the file path to its initials
      -- See Flexible Components section below for dynamic truncation
      -- if not conditions.width_percent_below(#filename, 0.25) then filename = vim.fn.pathshorten(filename) end
      -- filename = vim.fn.pathshorten(filename)
      return filename
    end,
  }
end

return M

-- 设计参考 VSCode

local M = {}

--- 返回文件在当前工作区的路径
function M.filename()
  return {
    init = function(self) self.filename = vim.api.nvim_buf_get_name(0) end,
    provider = function(self)
      -- first, trim the pattern relative to the current directory. For other
      -- options, see :h filename-modifers
      --- TODO: 在FileName 前添加 icon
      local filename = vim.fn.fnamemodify(self.filename, ":.")
      if filename == "" then return "[No Name]" end
      if string.len(filename) > 40 then filename = vim.fn.pathshorten(filename) end
      return filename
    end,
  }
end

--- 返回文件的基本信息，包含(filetype, encoding, eol)
function M.file_info()
  return {
    provider = function()
      -- end of line
      local eol = "LF"
      if vim.bo.fileformat == "unix" then
        eol = "LF"
      elseif vim.bo.fileformat == "dos" then
        eol = "CRLF"
      else
        eol = "CR"
      end
      local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
      return " " .. eol .. " " .. enc:upper() .. " " .. string.gsub(vim.bo.filetype, "^(.)", string.upper)
    end,
  }
end
return M

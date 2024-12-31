local M = {}

function M.mode() end

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

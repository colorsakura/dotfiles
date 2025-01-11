local icons = require("core.config").icons

local M = {}

-- Decide whether to truncate
local function is_truncated(trunc_width)
  -- Use -1 to default to 'not truncated'
  return vim.o.columns < (trunc_width or -1)
end

function M.mode()
  -- See :h mode()
  -- Note that: \19 = ^S and \22 = ^V.
  local mode_str = {
    n = "N",
    no = "N?",
    nov = "N?",
    noV = "N?",
    ["no\22"] = "N?",
    niI = "Ni",
    niR = "Nr",
    niV = "Nv",
    nt = "Nt",
    v = "V",
    vs = "Vs",
    V = "V_",
    Vs = "Vs",
    ["\22"] = "^V",
    ["\22s"] = "^V",
    s = "S",
    S = "S_",
    ["\19"] = "^S",
    i = "I",
    ic = "Ic",
    ix = "Ix",
    R = "R",
    Rc = "Rc",
    Rx = "Rx",
    Rv = "Rv",
    Rvc = "Rv",
    Rvx = "Rv",
    c = "C",
    cv = "Ex",
    r = "...",
    rm = "M",
    ["r?"] = "?",
    ["!"] = "!",
    t = "T",
  }
  local mode_hl = {
    n = "StlModeNormal",
    v = "StlModeVisual",
    i = "StlModeInsert",
    c = "StlModeCommand",
    r = "StlModeReplace",
    t = "StlModeTerminal",
  }
  local mode = vim.api.nvim_get_mode().mode
  return string.format("%%#%s#%s%%* %s", mode_hl[mode], icons.misc.mode, mode_str[mode])
end

function M.branch(trunc_width)
  local head = vim.b.minigit_summary_string or vim.b.gitsigns_head
  if not head then return "" end
  -- Don't show icon when truncated
  if is_truncated(trunc_width) then return head end
  return string.format("%%#StlIcon#%s%%*%s", icons.git.branch, head)
end

-- TODO:
function M.diff(trunc_width)
  local status = vim.b.gitsigns_status_dict
  if not status or is_truncated(trunc_width) then return "" end
  local git_diff = {
    added = status.added,
    deleted = status.removed,
    modified = status.changed,
  }
  local result = {}
  for _, type in ipairs { "added", "deleted", "modified" } do
    if git_diff[type] and git_diff[type] > 0 then
      local format_str = "%%#StlGit" .. type .. "#%s%s%%*"
      table.insert(result, string.format(format_str, icons.git[type], git_diff[type]))
    end
  end
  if #result > 0 then
    return table.concat(result, " ")
  else
    return ""
  end
end

-- LSP clients of all buffers
-- Mark (e.g., using green color) the clients attaching to the current buffer
function M.lsp(trunc_width)
  if is_truncated(trunc_width) then return "" end
  local clients = vim.lsp.get_clients()
  local client_names = {}
  for _, client in ipairs(clients) do
    if client and client.name ~= "" then
      local attached_buffers = client.attached_buffers
      if attached_buffers[vim.api.nvim_get_current_buf()] then
        table.insert(client_names, string.format("%%#StlComponentOn#%s%%*", client.name))
      else
        table.insert(client_names, client.name)
      end
    end
  end
  if next(client_names) == nil then return "%#StlComponentInactive#[LS Inactive]%*" end
  return string.format("[%s]", table.concat(client_names, ", "))
end

-- lint
function M.lint()
  local ok, lint = pcall(require, "lint")
  if not ok then return "" end
  local linters = lint.get_running()
  if #linters == 0 then return "󰦕 " end
  return "󱉶 " .. table.concat(linters, ", ")
end

-- Search count
function M.search()
  if vim.v.hlsearch == 0 then return "" end
  local ok, s_count = pcall(vim.fn.searchcount, { recompute = true })
  if not ok or s_count.current == nil or s_count.total == 0 then return "" end
  if s_count.incomplete == 1 then return string.format("%%#StlSearchCnt#%s%s%%*", icons.misc.search, "[?/?]") end
  local too_many = string.format(">%d", s_count.maxcount)
  local current = s_count.current > s_count.maxcount and too_many or s_count.current
  local total = s_count.total > s_count.maxcount and too_many or s_count.total
  return string.format("%%#StlSearchCnt#%s[%s/%s]%%*", icons.misc.search, current, total)
end

-- Autoformat (format-on-save)
function M.format()
  if not vim.g.autoformat and not vim.b.autoformat then return "" end
  -- Type of the autoformat: G for global and B for buffer-local
  local type = vim.g.autoformat and "[G]" or (vim.b.autoformat and "[B]" or "")
  return string.format("%%#StlComponentOn#%s%%*%s", icons.misc.format, type)
end

-- Diagnostics
local diagnostic_levels = {
  { name = "ERROR", icon = icons.diagnostics.ERROR },
  { name = "WARN", icon = icons.diagnostics.WARN },
  { name = "INFO", icon = icons.diagnostics.INFO },
  { name = "HINT", icon = icons.diagnostics.HINT },
}
function M.diagnostic()
  local counts = vim.diagnostic.count(0)
  local res = {}
  for _, level in ipairs(diagnostic_levels) do
    local n = counts[vim.diagnostic.severity[level.name]] or 0
    if n > 0 then
      if vim.diagnostic.is_enabled() then
        table.insert(res, string.format("%%#StlDiagnostic%s#%s%s%%*", level.name, level.icon, n))
      else
        -- Use gray color if diagnostic is disabled
        table.insert(res, string.format("%%#StlComponentInactive#%s%s%%* ", level.icon, n))
      end
    end
  end
  return table.concat(res, " ")
end

-- supermaven statusline
-- TODO: 添加激活颜色组
function M.supermaven()
  local ok, _ = pcall(require, "supermaven-nvim")
  if not ok then return "" end
  local res = "%%#StlSupermaven#%s"
  return string.format(res, icons.misc.Supermaven)
end

function M.spell(trunc_width)
  if is_truncated(trunc_width) then return "" end
  if vim.o.spell then return string.format("%%#StlComponentOn#%s%%*", icons.misc.check) end
  return ""
end

-- Treesitter status
-- Use different colors to denote whether it has a parser for the
-- current file and whether the highlight is enabled:
-- * gray  : no parser
-- * green : has parser and highlight is enabled
-- * red   : has parser but highlight is disabled
function M.treesitter()
  local res = icons.misc.tree
  local buf = vim.api.nvim_get_current_buf()
  local hl_enabled = vim.treesitter.highlighter.active[buf]
  local has_parser = require("nvim-treesitter.parsers").has_parser()
  if not has_parser then return string.format("%%#StlComponentInactive#%s%%*", res) end
  local format_str = hl_enabled and "%%#StlComponentOn#%s%%*" or "%%#StlComponentOff#%s%%*"
  return string.format(format_str, res)
end

-- Indent type (tab or space) and number of spaces
function M.indent(trunc_width)
  if is_truncated(trunc_width) then return "" end
  local get_local_option = function(option_name) return vim.api.nvim_get_option_value(option_name, { scope = "local" }) end
  local expandtab = get_local_option "expandtab"
  local spaces_cnt = expandtab and get_local_option "shiftwidth" or get_local_option "tabstop"
  local res = (expandtab and "SP:" or "TAB:") .. spaces_cnt
  return string.format("%s", res)
end

function M.encoding(trunc_width)
  if is_truncated(trunc_width) then return "" end
  local encoding = vim.bo.fileencoding
  if vim.bo.bomb then return encoding:upper() .. "[BOM]" end
  return encoding:upper()
end

function M.filetype()
  local filetype = string.gsub(vim.bo.filetype, "^(.)", string.upper)
  return filetype
end

-- TODO: 新增选择文本字数计数
function M.location()
  local res = "%l:%v"
  return table.concat {
    string.format("%%#StlLocComponent# %s%s", res, ""),
  }
end

function M.render()
  local function concat_components(components, sep)
    return vim.iter(components):fold("", function(acc, component)
      if #component > 0 then return #acc == 0 and component or string.format("%s%s%s", acc, sep, component) end
      return acc
    end)
  end

  return table.concat({
    M.mode(),
    M.branch(120),
    "%=",
    concat_components({
      M.search(),
      M.format(),
      M.location(),
      M.supermaven(),
      M.spell(120),
      M.lint(),
      -- M.treesitter(),
      M.indent(120),
      M.encoding(120),
      M.filetype(),
    }, " "),
  }, " ")
end

-- Refresh
local group = vim.api.nvim_create_augroup("statusline", {})
-- After gitsigns update
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "GitSignsUpdate",
  callback = function() vim.cmd.redrawstatus() end,
})

vim.o.statusline = "%!v:lua.require('core.ui.statusline').render()"

return M

-------------------------------------------
---| A  |  B |                        |1|2|
-------------------------------------------

local M = {}

local icons = require("core.config").icons

---Get get the filetype icon and the title
---@param bufnr number The winid of the current window in the tabpage.
---@param is_cur boolean Whether it's the current tabpage. It's used to set the highlight group for
---icons.
---@param title_hl string The highlight group for this tab title part.
---@return string
local function get_icon_and_title(bufnr, is_cur, title_hl)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local filetype = vim.bo[bufnr].filetype
    local title = vim.fn.fnamemodify(bufname, ":t")
    if filetype == "git" then title = "Git" end
    local has_devicons, devicons = pcall(require, "nvim-web-devicons")
    if has_devicons then
        local icon, icon_color = devicons.get_icon_color_by_filetype(filetype, { default = true })
        return string.format("%s %s", icon, title)
    end
    return icons.misc.file .. title
end

function M.render()
    local tabs = {}
    local bufs = {}

    -- Render each buffer
    for i, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        local is_scratch = vim.bo[bufnr].buflisted
        local is_cur = vim.api.nvim_get_current_buf() == bufnr

        if is_scratch then
            local items = {}

            local buf_title = get_icon_and_title(bufnr, is_cur, "")
            table.insert(items, buf_title)
            local buf = string.format("%%#%s# %s%%#%s#%s", is_cur and "TabLineSel" or "TabLine", table.concat(items, " "),
                is_cur and "TabIndicatorActive" or "TabIndicatorInactive", icons.separators.bar_right_bold)

            table.insert(bufs, buf)
        end
    end

    -- Render each tab
    for i, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
        local items = {}
        table.insert(items, i)

        local tab = string.format("%%#%s#%s ", "TabLineSel", table.concat(items, " "))

        table.insert(tabs, tab)
    end

    -- Assemble the complete tabline for all tabs
    local bufline = table.concat(bufs)
    local tabline = table.concat(tabs)

    if #tabs == 1 then tabline = "" end

    return table.concat {
        bufline,
        "%#TabLineFilee#%=",
        tabline,
    }
end

M.options = {
    exclude_filetypes = { "snacks_dashboard", "help", "neo-tree" },
}

function M.setup()
    vim.o.showtabline = 2
    vim.o.hidden = true
    vim.o.tabline = "%{%v:lua.require('core.ui.tabline').render()%}"
end

return M

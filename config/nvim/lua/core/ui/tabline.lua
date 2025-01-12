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
        return string.format("%s%%#%s# %s", icon, title_hl, title)
    end
    return icons.misc.file .. title
end

function M.render()
    local tabs = {}
    local bufs = {}

    -- Render each buffer
    for i, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        local buftype = vim.bo[bufnr].buftype
        local is_scratch = (buftype == "acwrite") or (buftype == "nofile")
        local is_cur = vim.api.nvim_get_current_buf() == bufnr

        if not is_scratch then
            local items = {}

            local buf_title = get_icon_and_title(bufnr, is_cur, "")
            table.insert(items, buf_title)
            local buf = string.format("%%#%s#%s ", is_cur and "TabLineSel" or "TabLine", table.concat(items, " "))

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

    if #tabs == 1 and #bufs == 1 then
        vim.o.showtabline = 0
        return ""
    end

    return table.concat {
        bufline,
        "%=",
        tabline,
    }
end

vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("tabline", { clear = true }),
    callback = function()
        local filetypes = { "snacks_dashboard", "neo-tree" }

        vim.o.showtabline = 2
        vim.o.tabline = "%{%v:lua.require('core.ui.tabline').render()%}"

        if vim.tbl_contains(filetypes, vim.bo.filetype) then vim.o.showtabline = 0 end
    end,
})

return M

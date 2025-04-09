-------------------------------------------
---| A  |  B |                        |1|2|
-------------------------------------------

-- TODO: 不同路径下的同名文件需要区分
local M = {}

local icons = require("core.config").icons

---Get get the filetype icon and the title
---@param bufnr number The winid of the current window in the tabpage.
---@param is_cur_buf boolean Whether it's the current tabpage. It's used to set the highlight group for icons.
---@return string
local function get_icon_and_title(bufnr, is_cur_buf)
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

local function get_valid_tabs()
    return vim.tbl_filter(function(t) return vim.api.nvim_tabpage_is_valid(t) end, vim.api.nvim_list_tabpages())
end

function M.render()
    local tabs = {}
    local bufs = {}

    -- Render each buffer
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        local is_listed = vim.bo[bufnr].buflisted
        local is_cur_buf = vim.api.nvim_get_current_buf() == bufnr

        if is_listed then
            local items = {}
            local buf_title = get_icon_and_title(bufnr, is_cur_buf)
            table.insert(items, buf_title)

            local buf = string.format(
                "%%#%s# %s%%#%s#%s",
                is_cur_buf and "TabLineSel" or "TabLine",
                table.concat(items, " "),
                is_cur_buf and "TabIndicatorActive" or "TabIndicatorInactive",
                icons.separators.bar_right_bold
            )

            table.insert(bufs, buf)
        end
    end

    -- Render each tab
    for i, tabpage in ipairs(get_valid_tabs()) do
        local items = {}
        local is_cur_tab = vim.api.nvim_get_current_tabpage() == tabpage
        table.insert(items, i)

        local tab = string.format("%%#%s# %s ", is_cur_tab and "TabLineSel" or "TabLine", table.concat(items, ""))

        table.insert(tabs, tab)
    end

    if #tabs == 1 then tabs = {} end

    return table.concat {
        table.concat(bufs),
        "%#TabLineFill#%=",
        table.concat(tabs),
    }
end

M.options = {
    exclude_buftypes = {},
    exclude_filetypes = { "snacks_dashboard", "neo-tree" },
}

function M.setup(opts)
    if not opts.enabled then return end

    vim.opt.showtabline = 2
    vim.opt.tabline = "%{%v:lua.require'core.ui.tabline'.render()%}"

    vim.api.nvim_create_autocmd(
        { "BufEnter", "BufWinEnter", "BufWinLeave", "BufWritePost", "TabEnter", "VimResized", "WinEnter", "WinLeave" },
        {
            group = vim.api.nvim_create_augroup("core.ui.tabline", { clear = true }),
            callback = function()
                local options = M.options
                if
                    vim.tbl_contains(options.exclude_buftypes, vim.bo.buftype)
                    or vim.tbl_contains(options.exclude_filetypes, vim.bo.filetype)
                then
                    if vim.opt.showtabline == 2 then vim.opt.showtabline = 0 end
                else
                    vim.opt.showtabline = 2
                end

                vim.cmd "redrawtabline"
            end,
        }
    )
end

return M

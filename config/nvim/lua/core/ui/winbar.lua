local M = {}

local icons = require("core.config").icons
local delimiter = icons.caret.right
local special_filetypes = {}

-- Cache the highlight groups created for different icons
local cached_hls = {}

local function path_component()
    -- Window with special filetype (like term, aerial, etc) does not have path component
    local ft = vim.bo.filetype
    local winid = vim.api.nvim_get_current_win()
    if special_filetypes[ft] or ft == "git" or vim.fn.win_gettype(winid) == "command" then return "" end
    -- Window with normal filetype displays the path of the file
    -- Winbar displays the path with two parts: prefix (icon and a pre-defined name) and path
    local fullpath = vim.fn.expand "%"
    if fullpath == "" then return "" end
    local icon = icons.misc.folder
    if string.find(fullpath, "^fugitive://") or string.find(fullpath, "^gitsigns://") then
        icon = icons.misc.source_control
    end
    local path = vim.fn.fnamemodify(fullpath, ":~:h")
    return string.format(" %%#WinbarPath#%s%s%%*", icon, path)
end

local function icon_component()
    local ft = vim.bo.filetype
    local winid = vim.api.nvim_get_current_win()
    -- Window with special filetype
    local fmt_str = "%%#WinbarSpecialIcon#%s%%*"
    if special_filetypes[ft] then return string.format(fmt_str, special_filetypes[ft].icon) end
    if vim.fn.win_gettype(winid) == "command" then return string.format(fmt_str, special_filetypes.cmdwin.icon) end
    -- Window with normal filetype
    local has_devicons, devicons = pcall(require, "nvim-web-devicons")
    if has_devicons then
        local icon, icon_color = devicons.get_icon_color_by_filetype(ft, { default = true })
        local icon_hl = "WinbarFileIconFor" .. ft
        if not cached_hls[icon_hl] then
            local bg_color = vim.api.nvim_get_hl(0, { name = "Winbar" }).bg
            vim.api.nvim_set_hl(0, icon_hl, { fg = icon_color, bg = bg_color })
            cached_hls[icon_hl] = true
        end
        return string.format("%%#%s#%s%%*", icon_hl, icon)
    end
    return icons.misc.file
end

local function name_component()
    -- For window with special filetype
    local ft = vim.bo.filetype
    local winid = vim.api.nvim_get_current_win()
    if ft == "aerial" then return "Outline [Aerial]" end
    if ft == "Outline" then return "Outline" end
    if ft == "floggraph" or ft == "fugitive" or ft == "oil" or ft == "term" then return vim.fn.expand "%" end
    if ft == "fugitiveblame" then return "Fugitive Blame" end
    if ft == "gitsigns.blame" then return "Gitsigns Blame" end
    if ft == "kitty_scrollback" then return "Kitty Scrollback" end
    if ft == "qf" then
        local is_loclist = vim.fn.win_gettype(winid) == "loclist"
        local type = is_loclist and "Location List" or "Quickfix List"
        local what = { title = 0, size = 0, idx = 0 }
        local list = is_loclist and vim.fn.getloclist(0, what) or vim.fn.getqflist(what)
        -- The output format is like {list type} > {list title} > {current idx}
        -- E.g., "Quickfix List > Diagnostics > [1/10]"
        local items = {}
        table.insert(items, type) -- type
        if list.title ~= "" then
            table.insert(items, list.title) -- title
        end
        table.insert(items, string.format("[%s/%s]", list.idx, list.size)) -- index
        return table.concat(items, " " .. delimiter .. " ")
    end
    if ft == "tagbar" then return "Tagbar" end
    if vim.fn.win_gettype(winid) == "command" then return "Command-line Window" end
    -- For window with normal filetype
    local filename = vim.fn.expand "%:t"
    if filename == "" then filename = "[No Name]" end
    return filename
end

local function navigation_component()
    local ok, navic = pcall(require, "nvim-navic")
    if not ok then return "" end
    local context = navic.get_location()
    local breadcrumbs = delimiter .. " " .. (context == "" and icons.misc.ellipsis or context)
    return breadcrumbs
end

M.render = function()
    -- clear winbar
    vim.o.winbar = nil

    if vim.bo.buftype ~= "" then return end
    if vim.tbl_contains(M.options.exclude_buftypes, vim.bo.buftype) then return end
    if vim.tbl_contains(M.options.exclude_filetypes, vim.bo.filetype) then return end

    local items = {}

    -- Path
    local path = path_component()
    if path ~= "" then
        table.insert(items, path)
        table.insert(items, delimiter)
    end

    -- File icon
    local icon = icon_component()
    table.insert(items, icon)

    -- Name
    local name = name_component()
    table.insert(items, string.format("%%#%s#%s%%*", "WinbarFilename", name))

    -- Truncate if too long
    items[#items] = items[#items] .. "%<"

    table.insert(items, navigation_component())

    local winbar = table.concat(items, " ")

    local ok, _ = pcall(vim.api.nvim_set_option_value, "winbar", winbar, { scope = "local" })
    if not ok then vim.notify("Failed to set winbar", vim.log.levels.ERROR) end
end

M.options = {
    exclude_filetypes = { "snacks_dashboard", "snacks_notif_history", "toggleterm", "help", "neo-tree" },
    exclude_buftypes = { "terminal" },
}

function M.setup(opts)
    if not opts.enabled then return end

    vim.api.nvim_create_autocmd({ "DirChanged", "CursorMoved", "BufFilePost", "InsertEnter", "BufWritePost" }, {
        group = vim.api.nvim_create_augroup("core.ui.winbar", { clear = true }),
        callback = function() M.render() end,
    })
end

return M

local fn = vim.fn

local M = {}

-- foldtext for Neovim < 0.10.0
function M.foldtext() return vim.api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum, false)[1] end

-- optimized treesitter foldexpr for Neovim >= 0.10.0
function M.foldexpr()
    local buf = vim.api.nvim_get_current_buf()
    if vim.b[buf].ts_folds == nil then
        -- as long as we don't have a filetype, don't bother
        -- checking if treesitter is available (it won't)
        if vim.bo[buf].filetype == "" then return "0" end
        if vim.bo[buf].filetype:find "dashboard" then
            vim.b[buf].ts_folds = false
        else
            vim.b[buf].ts_folds = pcall(vim.treesitter.get_parser, buf)
        end
    end
    return vim.b[buf].ts_folds and vim.treesitter.foldexpr() or "0"
end

local no_blank = function(str)
    local nonSpaceMatch = string.match(str, "%S")
    if nonSpaceMatch then
        local startIndex = string.find(str, nonSpaceMatch)
        str = string.sub(str, startIndex)
    end
    return str
end

function M.qftf(info)
    local items
    local ret = {}
    -- The name of item in list is based on the directory of quickfix window.
    -- Change the directory for quickfix window make the name of item shorter.
    -- It's a good opportunity to change current directory in quickfixtextfunc :)
    --
    -- local alterBufnr = fn.bufname('#') -- alternative buffer is the buffer before enter qf window
    -- local root = getRootByAlterBufnr(alterBufnr)
    -- vim.cmd(('noa lcd %s'):format(fn.fnameescape(root)))
    --
    if info.quickfix == 1 then
        items = fn.getqflist({ id = info.id, items = 0 }).items
    else
        items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
    end
    local limit = 31
    local fnameFmt1, fnameFmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
    local validFmt = "%s │%5d:%-3d│%s %s"
    for i = info.start_idx, info.end_idx do
        local e = items[i]
        local fname = ""
        local str
        if e.valid == 1 then
            if e.bufnr > 0 then
                fname = fn.bufname(e.bufnr)
                if fname == "" then
                    fname = "[No Name]"
                else
                    fname = fname:gsub("^" .. vim.env.HOME, "~")
                end
                -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
                if #fname <= limit then
                    fname = fnameFmt1:format(fname)
                else
                    fname = fnameFmt2:format(fname:sub(1 - limit))
                end
            end
            local lnum = e.lnum > 99999 and -1 or e.lnum
            local col = e.col > 999 and -1 or e.col
            local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
            str = validFmt:format(fname, lnum, col, qtype, no_blank(e.text))
        else
            str = e.text
        end
        table.insert(ret, str)
    end
    return ret
end

return M

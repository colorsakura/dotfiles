local M = {}

setmetatable(M, {
    __index = function(t, k)
        t[k] = require("core.util." .. k)
        return t[k]
    end,
})

function M.is_win() return vim.uv.os_uname().sysname:find "Windows" ~= nil end

--- This extends a deeply nested list with a key in a table
--- that is a dot-separated string.
--- The nested list will be created if it does not exist.
---@generic T
---@param t T[]
---@param key string
---@param values T[]
---@return T[]?
function M.extend(t, key, values)
    local keys = vim.split(key, ".", { plain = true })
    for i = 1, #keys do
        local k = keys[i]
        t[k] = t[k] or {}
        if type(t) ~= "table" then return end
        t = t[k]
    end
    return vim.list_extend(t, values)
end

-- delay notifications till vim.notify was replaced or after 500ms
function M.lazy_notify()
    local notifs = {}
    local function temp(...) table.insert(notifs, vim.F.pack_len(...)) end

    local orig = vim.notify
    vim.notify = temp

    local timer = vim.uv.new_timer()
    local check = assert(vim.uv.new_check())

    local replay = function()
        timer:stop()
        check:stop()
        if vim.notify == temp then
            vim.notify = orig -- put back the original notify if needed
        end
        vim.schedule(function()
            ---@diagnostic disable-next-line: no-unknown
            for _, notif in ipairs(notifs) do
                vim.notify(vim.F.unpack_len(notif))
            end
        end)
    end

    -- wait till vim.notify has been replaced
    check:start(function()
        if vim.notify ~= temp then replay() end
    end)
    -- or if it took more than 500ms, then something went wrong
    timer:start(500, 0, replay)
end

function M.get_git_ignored_files_in(dir)
    local found = vim.fs.find(".git", {
        upward = true,
        path = dir,
    })
    if #found == 0 then return {} end

    local cmd =
        string.format('git -C %s ls-files --ignored --exclude-standard --others --directory | grep -v "/.*\\/"', dir)

    local handle = io.popen(cmd)
    if handle == nil then return end

    local ignored_files = {}
    for line in handle:lines "*l" do
        line = line:gsub("/$", "")
        table.insert(ignored_files, line)
    end
    handle:close()

    return ignored_files
end

---@generic T
---@param list T[]
---@return T[]
function M.dedup(list)
    local ret = {}
    local seen = {}
    for _, v in ipairs(list) do
        if not seen[v] then
            table.insert(ret, v)
            seen[v] = true
        end
    end
    return ret
end

M.CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
function M.create_undo()
    if vim.api.nvim_get_mode().mode == "i" then vim.api.nvim_feedkeys(M.CREATE_UNDO, "n", false) end
end

local cache = {} ---@type table<(fun()), table<string, any>>
---@generic T: fun()
---@param fn T
---@return T
function M.memoize(fn)
    return function(...)
        local key = vim.inspect { ... }
        cache[fn] = cache[fn] or {}
        if cache[fn][key] == nil then cache[fn][key] = fn(...) end
        return cache[fn][key]
    end
end

return M

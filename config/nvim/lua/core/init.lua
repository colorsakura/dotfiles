local first_run = not _G.Core

_G.Core = {}

setmetatable(_G.Core, {
    __index = function(t, k)
        t[k] = require("core." .. k)
        return t[k]
    end,
})

local M = Core

function M.lazy()
    local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        vim.fn.system { "git", "clone", "--filter=blob:none", lazyrepo, lazypath }
    end
    vim.opt.rtp:prepend(lazypath)
end

function M.setup(opts)
    Core.config.setup(opts)

    Core.ui.setup()

    M.lazy()

    if first_run then
        local ok, _ = pcall(require, "lazy")
        if ok then require("editor").setup() end
    end
end

return M

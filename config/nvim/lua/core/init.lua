local M = {}

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then error("Error cloning lazy.nvim:\n" .. out) end
end
vim.opt.rtp:prepend(lazypath)

function M.setup(opts)
    Core.config.setup(opts)

    Core.ui.setup()

    local ok, _ = pcall(require, "lazy")
    if ok then require("editor").setup() end
end

_G.Core = {}

setmetatable(_G.Core, {
    __index = function(t, k)
        t[k] = require("core." .. k)
        return t[k]
    end,
})

return M

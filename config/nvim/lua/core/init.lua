_G.Core = require "core.util"

local M = {}

function M.setup(opts)
    require("core.config").setup(opts)

    require("core.ui").setup()

    require("core.lsp").setup()

    M.lazy()

    local ok, lazy = pcall(require, "lazy")
    if ok then
        require("editor").setup()
    end
end

function M.lazy()
    local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        vim.system(
            { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath },
            { text = true },
            function(result) print(result) end
        )
    end
    vim.opt.rtp:prepend(lazypath)
end

return M

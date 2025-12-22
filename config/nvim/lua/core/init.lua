local M = {}

function M.setup(opts)
    Core.config.setup(opts)

    if vim.fn.has "nvim-0.12.0" == 1 then 
        Core.pack.setup()
        Core.lsp.setup()
    end
end

_G.Core = {}

setmetatable(_G.Core, {
    __index = function(t, k)
        t[k] = require("core." .. k)
        return t[k]
    end,
})

return M

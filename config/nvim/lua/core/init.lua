local M = {}

function M.setup(opts)
    Core.config.setup(opts)
end

_G.Core = {}

setmetatable(_G.Core, {
    __index = function(t, k)
        t[k] = require("core." .. k)
        return t[k]
    end,
})

return M

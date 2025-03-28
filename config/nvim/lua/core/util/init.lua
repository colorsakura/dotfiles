local M = {}

setmetatable(M, {
    __index = function(t, k)
        t[k] = require("core.util." .. k)
        return t[k]
    end,
})

return M

local M = {}

setmetatable(M, {
    __index = function(t, k)
        t[k] = require("core.ui." .. k)
        return t[k]
    end,
})

local default = {
    statusline = {
        enabled = true,
    },
    tabline = {
        enabled = true,
    },
    winbar = {
        enabled = true,
    },
    statuscolumn = {
        enabled = false,
    },
}

function M.setup(opts)
    require "core.ui.statusline".setup()
    require "core.ui.tabline".setup()
    require "core.ui.winbar".setup()
end

return M

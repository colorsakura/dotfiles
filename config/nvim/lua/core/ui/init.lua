local M = {}

setmetatable(M, {
    __index = function(t, k)
        t[k] = require("core.ui." .. k)
        return t[k]
    end,
})

M.default = {
    statusline = {
        enabled = true,
    },
    tabline = {
        enabled = false,
    },
    winbar = {
        enabled = true,
    },
    statuscolumn = {
        enabled = false,
    },
}

function M.setup(options)
    local opts = options or M.default

    -- M.statuscolumn.setup(opts.statuscolumn)
    M.statusline.setup(opts.statusline)
    M.tabline.setup(opts.tabline)
    M.winbar.setup(opts.winbar)
end

return M

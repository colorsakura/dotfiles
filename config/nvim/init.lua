if vim.loader then vim.loader.enable() end

local first_run = not _G.Core

package.loaded.core = nil
_G.Core = require "core"

if first_run then
    vim.cmd [[autocmd VimEnter * lua _G.Core.setup()]]
else
    _G.Core.setup()
end

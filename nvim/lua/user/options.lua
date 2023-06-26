-- set vim options here (vim.<first_key>.<second_key> = value)
-- return {
--   opt = {
--     -- set to true or false etc.
--     relativenumber = true, -- sets vim.opt.relativenumber
--     number = true,         -- sets vim.opt.number
--     spell = false,         -- sets vim.opt.spell
--     signcolumn = "auto",   -- sets vim.opt.signcolumn to auto
--     wrap = false,          -- sets vim.opt.wrap
--   },
--   g = {
--     mapleader = " ",                 -- sets vim.g.mapleader
--     autoformat_enabled = true,       -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
--     cmp_enabled = true,              -- enable completion at start
--     autopairs_enabled = true,        -- enable autopairs at start
--     diagnostics_mode = 3,            -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
--     icons_enabled = true,            -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
--     ui_notifications_enabled = true, -- disable notifications when toggling UI elements
--   },
-- }
-- If you need more control, you can use the function()...end notation
return function(local_vim)
    local_vim.opt.modelines = 1

    local_vim.g.mapleader = " "
    local_vim.g.encoding = "utf-8"
    local_vim.g.tabstop = 8
    local_vim.g.smoothscroll = true
    local_vim.g.inlay_hints_enabled = true

    -- vim copyright plugin
    local_vim.g.file_copyright_name = "iFlygo"
    local_vim.g.file_copyright_email = "iflygo@outlook.com"

    local_vim.g.python_host_skip_check = 1
    local_vim.g.python3_host_prog = "/usr/bin/python3"

    return local_vim
end

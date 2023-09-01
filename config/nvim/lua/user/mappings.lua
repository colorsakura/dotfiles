-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
    -- First key is the mode
    n = {
        ["<M-1>"] = { "<cmd>Neotree toggle<cr>" },
        ["<M-2>"] = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>" },
    },
    v = {},
    t = {
        ["<M-2>"] = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>" },
    },
}

return {
    {
        "stevearc/oil.nvim",
        cond = function() return not Editor.has "neo-tree.nvim" end,
        lazy = true,
        event = "VeryLazy",
        cmd = "Oil",
        keys = {
            { "<leader>e", function() require("oil").open_float() end, desc = "Explorer(cwd)" },
        },
        opts = function()
            local oil = require "oil"
            return {
                default_file_explorer = true,
                columns = {
                    "icon",
                    "size",
                    "mtime",
                },
                view_options = {},
                keymaps = {
                    ["g?"] = { "actions.show_help", mode = "n" },
                    ["<CR>"] = "actions.select",
                    ["<C-s>"] = { "actions.select", opts = { vertical = true } },
                    ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
                    ["<C-t>"] = { "actions.select", opts = { tab = true } },
                    ["<C-p>"] = "actions.preview",
                    ["<C-c>"] = { "actions.close", mode = "n" },
                    ["<C-l>"] = "actions.refresh",
                    ["-"] = { "actions.parent", mode = "n" },
                    ["_"] = { "actions.open_cwd", mode = "n" },
                    ["`"] = { "actions.cd", mode = "n" },
                    ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
                    ["gs"] = { "actions.change_sort", mode = "n" },
                    ["gx"] = "actions.open_external",
                    ["g."] = { "actions.toggle_hidden", mode = "n" },
                    ["g\\"] = { "actions.toggle_trash", mode = "n" },
                },
                use_default_keymaps = false,
                float = {},
            }
        end,
        config = function(_, opts) require("oil").setup(opts) end,
    },
}

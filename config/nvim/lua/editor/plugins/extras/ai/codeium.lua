return {
    -- codeium
    -- FIXME: 当虚拟文本补全超过一行时, 补全浮窗会遮挡虚拟文本
    -- FIXME: 在neo-tree-popup中，应当禁用Codeium
    {
        "Exafunction/codeium.nvim",
        cmd = "Codeium",
        event = "InsertEnter",
        build = ":Codeium Auth",
        cond = function() return vim.g.ai == "codeium" end,
        opts = {
            enable_cmp_source = false,
            enable_chat = false,
            virtual_text = {
                enabled = true,
                filetypes = {
                    bash = true,
                    c = true,
                    go = true,
                    javascript = true,
                    lua = true,
                    markdown = false,
                    python = true,
                    rust = true,
                    zig = true,
                },
                default_filetype_enabled = true,
                key_bindings = {
                    accept = "<C-Enter>",
                    clear = "<C-l>",
                    next = "<A-]>",
                    prev = "<A-[>",
                },
            },
        },
        config = function(_, opts) require("codeium").setup(opts) end,
    },
}

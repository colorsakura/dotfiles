return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                fish_lsp = {
                    cmd = { "fish-lsp" },
                },
            },
        },
    },
    -- mason has no fish_lsp
    -- {
    --     "williamboman/mason.nvim",
    --     opts = { ensure_installed = { "fish_lsp" } },
    -- },
}

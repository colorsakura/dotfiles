return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                bashls = {
                    filetypes = { "sh", "bash", "zsh" },
                },
            },
        },
    },
    {
        "williamboman/mason.nvim",
        opts = { ensure_installed = { "bash-language-server" } },
    },
}

return {
    -- Add the community repository of plugin specifications
    "AstroNvim/astrocommunity",
    { import = "astrocommunity.motion.mini-ai" },
    { import = "astrocommunity.colorscheme.catppuccin" },

    {
        "catppuccin",
        opts = {
            transparent_background = false,
            integrations = {
                sandwich = false,
                noice = true,
                mini = true,
                leap = true,
                markdown = true,
                neotest = true,
                cmp = true,
                overseer = true,
                lsp_trouble = true,
                ts_rainbow2 = true,
            },
        },
        { import = "astrocommunity.pack.bash" },
        { import = "astrocommunity.pack.json" },
        { import = "astrocommunity.pack.lua" },
        { import = "astrocommunity.pack.markdown" },
        { import = "astrocommunity.pack.nix" },
        { import = "astrocommunity.pack.python" },
        { import = "astrocommunity.pack.rust" },
        { import = "astrocommunity.pack.yaml" },
        { import = "astrocommunity.pack.toml" },
    },
    -- example of imporing a plugin, comment out to use it or add your own
    -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

    -- { import = "astrocommunity.colorscheme.catppuccin" },
    -- { import = "astrocommunity.completion.copilot-lua-cmp" },
}

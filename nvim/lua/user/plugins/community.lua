return {
    -- Add the community repository of plugin specifications
    "AstroNvim/astrocommunity",
    { import = "astrocommunity.colorscheme.tokyonight-nvim" },
    { import = "astrocommunity.editing-support.todo-comments-nvim" },

    { import = "astrocommunity.pack.json" },
    { import = "astrocommunity.pack.lua" },
    { import = "astrocommunity.pack.markdown" },
    { import = "astrocommunity.pack.python" },
    { import = "astrocommunity.pack.go" },
    { import = "astrocommunity.pack.rust" },
    { import = "astrocommunity.pack.yaml" },
    { import = "astrocommunity.pack.toml" },
    -- -- example of importing a plugin, comment out to use it or add your own
    -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

    -- { import = "astrocommunity.colorscheme.catppuccin" },
    -- { import = "astrocommunity.completion.copilot-lua-cmp" },
}

return {
    -- Add the community repository of plugin specifications
    "AstroNvim/astrocommunity",

    { import = "astrocommunity.colorscheme.tokyonight-nvim" },

    { import = "astrocommunity.pack.bash" },
    { import = "astrocommunity.pack.cpp" },
    { import = "astrocommunity.pack.go" },
    { import = "astrocommunity.pack.html-css" },
    { import = "astrocommunity.pack.json" },
    { import = "astrocommunity.pack.lua" },
    { import = "astrocommunity.pack.markdown" },
    { import = "astrocommunity.pack.python" },
    { import = "astrocommunity.pack.rust" },
    { import = "astrocommunity.pack.toml" },

    { import = "astrocommunity.editing-support.todo-comments-nvim" },
    { import = "astrocommunity.markdown-and-latex.glow-nvim" },

    { import = "astrocommunity.syntax.vim-easy-align" },
}

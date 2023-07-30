return {
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function(plugin, opts)
            require "plugins.configs.luasnip" (plugin, opts)
            -- Add more custom luasnip configuration such as filetype extend or custom snippets
            local luasnip = require "luasnip.loaders.from_vscode"
            luasnip.lazy_load { paths = { "./lua/user/snippets" } }
        end,
    },
}

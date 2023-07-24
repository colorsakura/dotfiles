return {
    -- {
    --     "hrsh7th/nvim-cmp",
    --     opts = function(_, opts)
    --         local lspkind_status_ok, lspkind = pcall(require, "lspkind")
    --         opts.formatting = {
    --             fields = { "kind", "abbr", "menu" },
    --             format = lspkind.cmp_format {
    --                 mode = "symbol",
    --                 before = function(entry, vim_item)
    --                     vim_item.menu = ({
    --                         nvim_lsp = "[Lsp]",
    --                         luasnip = "[Luasnip]",
    --                         buffer = "[File]",
    --                         path = "[Path]",
    --                     })[entry.source.name]
    --                     return vim_item
    --                 end,
    --             },
    --         }
    --     end,
    -- },
    -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function(plugin, opts)
            require "plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
            -- add more custom luasnip configuration such as filetype extend or custom snippets
            local luasnip = require "luasnip.loaders.from_vscode"
            luasnip.lazy_load { paths = { "./lua/user/snippets" } }
        end,
    },
}

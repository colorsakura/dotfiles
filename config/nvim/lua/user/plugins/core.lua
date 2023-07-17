return {
    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            local lspkind_status_ok, lspkind = pcall(require, "lspkind")
            opts.formatting = {
                fields = { "kind", "abbr", "menu" },
                format = lspkind.cmp_format {
                    mode = "symbol",
                    before = function(entry, vim_item)
                        vim_item.menu = ({
                            nvim_lsp = "[Lsp]",
                            luasnip = "[Luasnip]",
                            buffer = "[File]",
                            path = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
            }
        end,
    },
}

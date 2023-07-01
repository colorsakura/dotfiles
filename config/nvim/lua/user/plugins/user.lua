return {
    -- You can also add new plugins here as well:
    -- Add plugins, the lazy syntax
    -- "andweeb/presence.nvim",
    -- {
    --   "ray-x/lsp_signature.nvim",
    --   event = "BufRead",
    --   config = function()
    --     require("lsp_signature").setup()
    --   end,
    -- },
    { "lilydjwg/fcitx.vim", event = "InsertEnter" },
    { "yianwillis/vimcdoc", event = "UIEnter" },
    {
        "NvChad/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup {
                user_default_options = {
                    RRGGBBAA = true,  -- #RRGGBBAA hex codes
                    AARRGGBB = false, -- 0xAARRGGBB hex codes
                    rgb_fn = true,    -- CSS rgb() and rgba() functions
                    hsl_fn = false,   -- CSS hsl() and hsla() functions
                    css = true,       -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                    css_fn = true,    -- Enable all CSS *functions*: rgb_fn, hsl_fn
                },
            }
        end,
    },
}

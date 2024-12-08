return {
  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    event = { "InsertEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        vim.schedule(
          function() require("luasnip.loaders.from_vscode").lazy_load() end
        )
        vim.schedule(
          function()
            require("luasnip.loaders.from_vscode").lazy_load {
              paths = "./snippets",
            }
          end
        )
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },
  {
    "saghen/blink.cmp",
		lazy = true,
    event = { "InsertEnter" },
    -- optional: provides snippets for the snippet source
    dependencies = {
      { "rafamadriz/friendly-snippets" },
    },
    version = "v0.*",
    -- build = "cargo build --release",
    opts = function (_, opts)
			opts.appearance = opts.appearance or {}
			opts.appearance.kind_icons = Editor.config.icons.kinds
    end
  },
}

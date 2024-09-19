return {
  -- Snippet
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        vim.schedule(function() require("luasnip.loaders.from_vscode").lazy_load() end)
      end,
    },
    lazy = true,
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },

  -- Cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-buffer", lazy = true },
      { "hrsh7th/cmp-cmdline", lazy = true },
      { "hrsh7th/cmp-nvim-lsp", lazy = true },
      { "hrsh7th/cmp-path", lazy = true },
      { "onsails/lspkind.nvim", lazy = true },
      { "saadparwaiz1/cmp_luasnip", lazy = true },
    },
    event = { "CmdlineEnter", "InsertEnter" },
    config = function()
      local cmp = require "cmp"
      local luasnip = require "luasnip"
      local default_sources = cmp.config.sources {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer" },
      }

      cmp.setup {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        preselect = cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.insert {
          ["<A-j>"] = cmp.mapping.scroll_docs(4),
          ["<A-k>"] = cmp.mapping.scroll_docs(-4),
          ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
          ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              local entry = cmp.get_selected_entry()
              if not entry then cmp.select_next_item { behavior = cmp.SelectBehavior.Select } end
              cmp.confirm()
            else
              fallback()
            end
          end, { "i", "s", "c" }),
        },
        sources = default_sources,
        formatting = {
          format = require("lspkind").cmp_format(),
        },
      }

      -- Use buffer source for `/` and `?`
      cmp.setup.cmdline({ "/", "?" }, {
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        sources = {
          { name = "buffer", keyword_length = 2 },
        },
      })

      -- Use cmdline & path source for ':'
      cmp.setup.cmdline(":", {
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        sources = cmp.config.sources({
          { name = "path", keyword_length = 2 },
        }, {
          { name = "cmdline", keyword_length = 2 },
        }),
      })
    end,
  },
}

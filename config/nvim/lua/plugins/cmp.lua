if vim.g.cmp_engine == "cmp" then
  return {
    -- Snippets
    {
      "L3MON4D3/LuaSnip",
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
    -- Cmp
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        { "hrsh7th/cmp-cmdline", lazy = true },
        { "hrsh7th/cmp-nvim-lsp", lazy = true },
        { "https://codeberg.org/FelipeLema/cmp-async-path", lazy = true },
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
          { name = "async_path" },
        }

        cmp.setup {
          completion = {
            completeopt = "menu,menuone,noinsert",
          },
          snippet = {
            expand = function(args) luasnip.lsp_expand(args.body) end,
          },
          preselect = cmp.PreselectMode.None,
          -- TODO: 按键不符合习惯
          mapping = cmp.mapping.preset.insert {
            ["<A-j>"] = cmp.mapping.scroll_docs(4),
            ["<A-k>"] = cmp.mapping.scroll_docs(-4),
            ["<C-j>"] = cmp.mapping.select_next_item {
              behavior = cmp.SelectBehavior.Select,
            },
            ["<C-k>"] = cmp.mapping.select_prev_item {
              behavior = cmp.SelectBehavior.Select,
            },
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                  cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                end
                cmp.confirm()
              else
                fallback()
              end
            end, { "i", "s", "c" }),
          },
          sources = default_sources,
        }

        -- Use buffer source for `/` and `?`
        cmp.setup.cmdline({ "/", "?" }, {
          completion = {
            completeopt = "menu,menuone,noselect",
          },
          sources = {},
        })

        -- Use cmdline & path source for ':'
        cmp.setup.cmdline(":", {
          completion = {
            completeopt = "menu,menuone,noselect",
          },
          sources = cmp.config.sources({
            { name = "async_path", keyword_length = 2 },
          }, {
            { name = "cmdline", keyword_length = 2 },
          }),
        })
      end,
    },
  }
else
  if vim.g.cmp_engine == "blink" then
    return {
      -- Snippets
      {
        "L3MON4D3/LuaSnip",
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
        event = { "InsertEnter" },
        -- optional: provides snippets for the snippet source
        dependencies = {
          { "rafamadriz/friendly-snippets" },
          { "onsails/lspkind.nvim" },
        },
        version = "v0.*",
        opts = {
          trigger = {
            signature_help = {
              enabled = true,
            },
          },
          highlight = {
            use_nvim_cmp_as_default = true,
          },
        },
      },
    }
  else
    return {}
  end
end

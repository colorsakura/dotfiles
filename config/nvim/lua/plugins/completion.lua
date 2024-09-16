return {
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

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      { "onsails/lspkind.nvim", lazy = true },
      { "hrsh7th/cmp-nvim-lsp", lazy = true },
      { "hrsh7th/cmp-buffer", lazy = true },
      { "hrsh7th/cmp-cmdline", lazy = true },
      { "hrsh7th/cmp-path", lazy = true },
      -- For luasnip users
      { "saadparwaiz1/cmp_luasnip", lazy = true },
    },
    config = function()
      local cmp = require "cmp"
      local luasnip = require "luasnip"

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
        sources = cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "luasnip" },
          { name = "buffer" },
        },
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

  {
    "kylechui/nvim-surround",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt", "vim" },
      check_ts = true,
      enable_check_bracket_line = true,
      fast_wrap = {
        chars = { "{", "(", "[", "<", '"', "'", "`" },
      },
    },
    -- TODO: remove this block when https://github.com/windwp/nvim-autopairs/pull/363 is merged
    config = function(opts)
      local autopairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      autopairs.setup(opts)
      autopairs.add_rules {
        Rule("<", ">"):with_pair(cond.before_regex "%a+"):with_move(function(o) return o.char == ">" end),
      }
    end,
    -- END TODO
  },

  -- Incremental LSP renaming based on Neovim's command-preview feature
  {
    "smjonas/inc-rename.nvim",
    keys = {
      {
        "grn",
        function() return ":IncRename " .. vim.fn.expand "<cword>" end,
        silent = true,
        expr = true,
      },
    },
    opts = {
      preview_empty_name = true,
    },
  },

  -- Sorting plugin that supports line-wise and delimiter sorting
  {
    "sQVe/sort.nvim",
    keys = {
      { "go", ":Sort<CR>", mode = "n", silent = true },
      { "go", "<Esc>:Sort<CR>", mode = "v", silent = true },
    },
  },
}

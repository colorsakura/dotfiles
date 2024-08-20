local icons = {
  Keyword = "󰌋",
  Operator = "󰆕",

  Text = "",
  Value = "󰎠",
  Constant = "󰏿",

  Method = "",
  Function = "󰊕",
  Constructor = "",

  Class = "",
  Interface = "",
  Module = "",

  Variable = "",
  Property = "󰜢",
  Field = "󰜢",

  Struct = "󰙅",
  Enum = "",
  EnumMember = "",

  Snippet = "",

  File = "",
  Folder = "",

  Reference = "󰈇",
  Event = "",
  Color = "",
  Unit = "󰑭",
  TypeParameter = "",
}

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
      { "hrsh7th/cmp-nvim-lsp", lazy = true },
      { "hrsh7th/cmp-buffer", lazy = true },
      { "hrsh7th/cmp-cmdline", lazy = true },
      { "hrsh7th/cmp-path", lazy = true },

      -- For luasnip users
      { "saadparwaiz1/cmp_luasnip", lazy = true },
    },
    config = function()
      local cmp = require "cmp"
      cmp.setup {
        preselect = cmp.PreselectMode.None,
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
          ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
          ["<M-k>"] = cmp.mapping.scroll_docs(-4),
          ["<M-j>"] = cmp.mapping.scroll_docs(4),
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<S-CR>"] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Replace },
        },
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
          { name = "luasnip" },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            item.kind = icons[item.kind] or item.kind

            local truncated = vim.fn.strcharpart(item.abbr, 0, 30)
            if truncated ~= item.abbr then item.abbr = truncated .. "…" end

            return item
          end,
        },
      }

      local mapping = {
        ["<Tab>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_next_item()
          else
            cmp.complete()
          end
        end, { "c" }),
        ["<S-Tab>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          else
            cmp.complete()
          end
        end, { "c" }),
      }

      -- Use buffer source for `/` and `?`
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = mapping,
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        sources = {
          { name = "buffer", keyword_length = 2 },
        },
      })

      -- Use cmdline & path source for ':'
      cmp.setup.cmdline(":", {
        mapping = mapping,
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
  {
    "echasnovski/mini.comment",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    keys = {
      { "<leader>c", nil, mode = { "n", "o", "x" } },
    },
    opts = {
      options = {
        ignore_blank_line = true,
      },
      mappings = {
        comment = "<leader>c",
        comment_line = "<leader>c",
        comment_visual = "<leader>c",
        textobject = "<leader>c",
      },
      hooks = {
        pre = function() require("ts_context_commentstring.internal").update_commentstring {} end,
      },
    },
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

  -- Generate sharable file permalinks (with line ranges) for git host websites
  {
    "ruifm/gitlinker.nvim",
    keys = {
      {
        "<leader>p",
        ':lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".copy_to_clipboard})<CR>',
        mode = "n",
        silent = true,
      },
      {
        "<leader>p",
        ':lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".copy_to_clipboard})<CR>',
        mode = "v",
        silent = true,
      },
    },
    config = function()
      require("gitlinker").setup {
        mappings = nil,
      }
    end,
  },
}

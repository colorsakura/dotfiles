return {
  -- Lsp config
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "williamboman/mason.nvim",
        lazy = true,
      },
      {
        "williamboman/mason-lspconfig.nvim",
        lazy = true,
      },
    },
    event = { "BufReadPre", "BufNewFile" },
    lazy = true,
    opts = {},
    config = function(_, opts)
      require("mason").setup()
      require("mason-lspconfig").setup()

      require("mason-lspconfig").setup_handlers {
        function(server) require("lspconfig")[server].setup {} end,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(event)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf })
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf, desc = "Goto definition" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf, desc = "Goto declaration" })
          vim.keymap.set("n", "gri", vim.lsp.buf.implementation, { buffer = event.buf, desc = "Goto implementation" })
          vim.keymap.set("n", "grr", vim.lsp.buf.references, { buffer = event.buf, desc = "Goto references" })
          vim.keymap.set({ "n", "x" }, "gra", vim.lsp.buf.code_action, { buffer = event.buf, desc = "Code action" })
          vim.keymap.set("n", "grn", vim.lsp.buf.rename, { buffer = event.buf, desc = "Code rename" })
        end,
      })
    end,
  },
  -- Lspsaga
  {
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
    event = { "BufReadPre", "BufNewFile" },
    lazy = true,
    opts = {
      ui = {},
      lightbulb = {
        enable = false,
      },
    },
    config = function(_, opts) require("lspsaga").setup(opts) end,
  },
  -- Formatter
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    keys = {
      {
        "grf",
        function() require("conform").format { async = true } end,
        mode = { "n" },
        desc = "Format buffer",
      },
    },
    config = function()
      require("conform").setup {
        formatters_by_ft = {
          c = { "clang-format" },
          lua = { "stylua" },
          rust = { "rustfmt", lsp_format = "fallback" },
          xml = { "xmlformat" },
          python = function(bufnr)
            if require("conform").get_formatter_info("ruff_format", bufnr).available then
              return { "ruff_format" }
            else
              return { "isort", "black" }
            end
          end,
          ["*"] = { "codespell" },
        },
        default_format_opts = {
          lsp_format = "fallback",
        },
      }
    end,
  },
  -- Integrating non-LSPs like Prettier
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local nls = require "null-ls"

      nls.setup {
        sources = {
          nls.builtins.code_actions.gitrebase,
          nls.builtins.code_actions.gitsigns,
        },
      }
    end,
  },
  -- Mason
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      pip = {
        upgrade_pip = true,
      },
      ui = {
        icons = {
          package_installed = "●",
          package_pending = "●",
          package_uninstalled = "○",
        },
        border = vim.g.border or "none",
        width = 0.65,
        height = 0.65,
      },
    },
  },
  -- Neovim dev
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  { -- optional completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },
}

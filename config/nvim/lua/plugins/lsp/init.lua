-- TODO: 简化lsp按键绑定
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local buf = event.buffer

    local ispreview = Editor.is_loaded "goto-preview"

    if ispreview then
      vim.keymap.set(
        "n",
        "<leader>uc",
        function() require("goto-preview").close_all_win() end,
        { desc = "Close All GotoPreview Windows" }
      )
    end

    vim.keymap.set("n", "K", function() vim.lsp.buf.hover { max_width = 40 } end, { buffer = buf, desc = "Hover" })
    vim.keymap.set("n", "grd", function()
      if ispreview then
        require("goto-preview").goto_preview_definition {}
      else
        vim.lsp.buf.definition()
      end
    end, { buffer = buf, desc = "Goto Declaration" })
    vim.keymap.set("n", "grt", function()
      if ispreview then
        require("goto-preview").goto_preview_type_definition {}
      else
        vim.lsp.buf.type_definition()
      end
    end, { buffer = buf, desc = "Goto Type Definition" })
    vim.keymap.set("n", "grD", function()
      if ispreview then
        require("goto-preview").goto_preview_declaration {}
      else
        vim.lsp.buf.declaration()
      end
    end, { buffer = buf, desc = "Goto Declaration" })
    vim.keymap.set("n", "gri", function()
      if ispreview then
        require("goto-preview").goto_preview_implementation {}
      else
        vim.lsp.buf.implementation()
      end
    end, { buffer = buf, desc = "Goto Implementation" })
    vim.keymap.set("n", "grr", function()
      if ispreview then
        require("goto-preview").goto_preview_references()
      else
        vim.lsp.buf.references()
      end
    end, { buffer = buf, desc = "Goto References" })
    vim.keymap.set("n", "grs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { buffer = buf })
    vim.keymap.set("n", "grn", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = buf, desc = "Code Rename" })
    vim.keymap.set(
      { "n", "x" },
      "grf",
      function() require("conform").format() end,
      { buffer = buf, desc = "Code Format" }
    )
    vim.keymap.set("n", "gra", "<cmd>lua vim.lsp.buf.code_action()<cr>", { buffer = buf, desc = "Code Action" })
  end,
})

return {
  {
    "neovim/nvim-lspconfig",
    event = { "LazyFile" },
    dependencies = {
      {
        "williamboman/mason.nvim",
      },
      {
        "williamboman/mason-lspconfig.nvim",
        config = function() end,
      },
    },
    opts = function()
      local ret = {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = Editor.config.icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = Editor.config.icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = Editor.config.icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = Editor.config.icons.diagnostics.Info,
            },
          },
        },
        inlay_hints = {
          enabled = true,
          exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        codelens = {
          enabled = false,
        },
        document_highlight = {
          enabled = true,
        },
        capabilfties = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        -- LSP Server Settings
        servers = {
          lua_ls = {
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
        },
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
      }
      return ret
    end,
    config = function(_, opts)
      -- diagnostics signs
      if type(opts.diagnostics.signs) ~= "boolean" then
        for severity, icon in pairs(opts.diagnostics.signs.text) do
          local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
          name = "DiagnosticSign" .. name
          vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
        end
      end

      -- inlay hints
      if opts.inlay_hints.enabled then
        Editor.lsp.on_supports_method("textDocument/inlayHint", function(client, buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      -- code lens
      if opts.codelens.enabled and vim.lsp.codelens then
        Editor.lsp.on_supports_method("textDocument/codeLens", function(client, buffer)
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = buffer,
            callback = vim.lsp.codelens.refresh,
          })
        end)
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has "nvim-0.10.0" == 0 and "●"
          or function(diagnostic)
            local icons = Editor.config.icons.diagnostics
            for d, icon in pairs(icons) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then return icon end
            end
          end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      require("mason").setup()
      require("mason-lspconfig").setup()

      require("mason-lspconfig").setup_handlers {
        function(server) require("lspconfig")[server].setup {} end,
      }
    end,
  },
  -- Mason
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "clangd",
        "clang-format",
        "prettier",
        "prettierd",
        "pyright",
        "ruff",
        "shfmt",
        "stylua", -- lua
        "lua-language-server",
        "marksman",
      },
      pip = {
        upgrade_pip = true,
      },
      ui = {
        icons = {
          package_installed = "●",
          package_pending = "●",
          package_uninstalled = "○",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require "mason-registry"
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger {
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          }
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then p:install() end
        end
      end)
    end,
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
  -- Goto Preview
  {
    "rmagatti/goto-preview",
    lazy = true,
    event = { "VeryLazy" },
    config = true,
  },
}
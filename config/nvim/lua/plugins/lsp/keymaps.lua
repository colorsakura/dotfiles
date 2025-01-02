---@diagnostic disable: missing-fields, missing-parameter
local M = {}

function M.setup()
  -- TODO: 简化lsp按键绑定
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      local opts = { buffer = event.buf }

      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "grr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "grs", vim.lsp.buf.signature_help, opts)
      vim.keymap.set("n", "grn", vim.lsp.buf.rename, { buffer = event.buf, desc = "Code Rename" })
      vim.keymap.set("n", "gra", vim.lsp.buf.code_action, { buffer = event.buf, desc = "Code Action" })
      vim.keymap.set(
        { "n", "x" },
        "grf",
        function() require("conform").format() end,
        { buffer = event.buf, desc = "Code Format" }
      )
      vim.keymap.set(
        "n",
        "grd",
        function() require("goto-preview").goto_preview_definition() end,
        { buffer = event.buf, desc = "Goto Definition" }
      )
      vim.keymap.set(
        "n",
        "grt",
        function() require("goto-preview").goto_preview_type_definition() end,
        { buffer = event.buf, desc = "Goto Type Definition" }
      )
      vim.keymap.set(
        "n",
        "grD",
        function() vim.lsp.buf.declaration() end,
        { buffer = event.buf, desc = "Goto Declaration" }
      )
      vim.keymap.set(
        "n",
        "gri",
        function() require("goto-preview").goto_preview_implementation() end,
        { buffer = event.buf, desc = "Goto Implementation" }
      )
    end,
  })
end

return M

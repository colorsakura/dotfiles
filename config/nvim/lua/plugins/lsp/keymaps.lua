local M = {}

function M.setup()
  -- TODO: 简化lsp按键绑定
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      local buffer = event.buffer

      vim.keymap.set("n", "K", function() vim.lsp.buf.hover {} end, { buffer = buffer, desc = "Hover" })
      vim.keymap.set("n", "grd", function() vim.lsp.buf.definition() end, { buffer = buffer, desc = "Goto Definition" })
      vim.keymap.set(
        "n",
        "grt",
        function() vim.lsp.buf.type_definition() end,
        { buffer = buffer, desc = "Goto Type Definition" }
      )
      vim.keymap.set(
        "n",
        "grD",
        function() vim.lsp.buf.declaration() end,
        { buffer = buffer, desc = "Goto Declaration" }
      )
      vim.keymap.set(
        "n",
        "gri",
        function() vim.lsp.buf.implementation() end,
        { buffer = buffer, desc = "Goto Implementation" }
      )
      vim.keymap.set("n", "grr", function()
        require("fzf-lua").lsp_references()
        -- vim.lsp.buf.references()
      end, { buffer = buffer, desc = "Goto References" })
      vim.keymap.set("n", "grs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { buffer = buffer })
      vim.keymap.set("n", "grn", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = buffer, desc = "Code Rename" })
      vim.keymap.set(
        { "n", "x" },
        "grf",
        function() require("conform").format() end,
        { buffer = buffer, desc = "Code Format" }
      )
      vim.keymap.set("n", "gra", "<cmd>lua vim.lsp.buf.code_action()<cr>", { buffer = buffer, desc = "Code Action" })
    end,
  })
end

return M

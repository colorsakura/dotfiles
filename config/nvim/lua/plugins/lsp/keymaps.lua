local M = {}

function M.setup()
  -- TODO: 简化lsp按键绑定
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      local bufnr = event.buf

      vim.keymap.set("n", "K", function() vim.lsp.buf.hover {} end, { buffer = bufnr, desc = "Hover" })
      vim.keymap.set("n", "grd", function() vim.lsp.buf.definition() end, { buffer = bufnr, desc = "Goto Definition" })
      vim.keymap.set(
        "n",
        "grt",
        function() vim.lsp.buf.type_definition() end,
        { buffer = bufnr, desc = "Goto Type Definition" }
      )
      vim.keymap.set(
        "n",
        "grD",
        function() vim.lsp.buf.declaration() end,
        { buffer = bufnr, desc = "Goto Declaration" }
      )
      vim.keymap.set(
        "n",
        "gri",
        function() vim.lsp.buf.implementation() end,
        { buffer = bufnr, desc = "Goto Implementation" }
      )
      vim.keymap.set(
        "n",
        "grr",
        function() vim.lsp.buf.references() end,
        { buffer = bufnr, nowait = true, desc = "Goto References" }
      )
      vim.keymap.set("n", "grs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { buffer = bufnr })
      vim.keymap.set("n", "grn", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = bufnr, desc = "Code Rename" })
      vim.keymap.set(
        { "n", "x" },
        "grf",
        function() require("conform").format() end,
        { buffer = bufnr, desc = "Code Format" }
      )
      vim.keymap.set("n", "gra", "<cmd>lua vim.lsp.buf.code_action()<cr>", { buffer = bufnr, desc = "Code Action" })
    end,
  })
end

return M

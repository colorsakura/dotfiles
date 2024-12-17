local M = {}

function M.setup()
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

      vim.keymap.set("n", "K", function() vim.lsp.buf.hover {} end, { buffer = buf, desc = "Hover" })
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
end

return M

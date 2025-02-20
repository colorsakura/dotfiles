---@diagnostic disable: missing-fields, missing-parameter
local M = {}

function M.setup()
    -- TODO: 简化lsp按键绑定
    vim.api.nvim_create_autocmd({ "LspAttach", "BufEnter" }, {
        callback = function(e)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = e.buf, desc = "Hover" })
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = e.buf, desc = "Goto Definition" })
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = e.buf, desc = "Goto Declaration" })
            vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { buffer = e.buf, desc = "Goto TypeDefinition" })
            vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { buffer = e.buf, desc = "Goto Implementation" })
            vim.keymap.set("n", "grr", vim.lsp.buf.references, { buffer = e.buf, desc = "Goto References" })
            vim.keymap.set("n", "grs", vim.lsp.buf.signature_help, { buffer = e.buf, desc = "Signature Help" })
            vim.keymap.set("n", "grn", vim.lsp.buf.rename, { buffer = e.buf, desc = "Code Rename" })
            vim.keymap.set("n", "gra", vim.lsp.buf.code_action, { buffer = e.buf, desc = "Code Action" })
            vim.keymap.set("n", "gri", vim.lsp.buf.implementation, { buffer = e.buf, desc = "Goto Implementation" })
            vim.keymap.set(
                { "n", "x" },
                "grf",
                function() require("conform").format() end,
                { buffer = e.buf, desc = "Code Format" }
            )
            vim.keymap.set(
                "n",
                "grd",
                function() require("goto-preview").goto_preview_definition() end,
                { buffer = e.buf, desc = "Goto Definition" }
            )
            vim.keymap.set(
                "n",
                "grt",
                function() require("goto-preview").goto_preview_type_definition() end,
                { buffer = e.buf, desc = "Goto Type Definition" }
            )
            vim.keymap.set(
                "n",
                "grD",
                function() vim.lsp.buf.declaration() end,
                { buffer = e.buf, desc = "Goto Declaration" }
            )
        end,
    })
end

return M

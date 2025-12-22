local M = {}

function M.setup()
    -- c
    vim.lsp.enable("clangd")
    -- lua
    vim.lsp.enable("lua_ls")
    -- python
    -- vim.lsp.enable("basedpyright")
    vim.lsp.enable("ruff")
    vim.lsp.enable("ty")
    -- go
    vim.lsp.enable("golsp")
    vim.lsp.enable("gofmt")
    -- zig
    vim.lsp.enable("zls")

    M.diagnostic_setup()
end

function M.diagnostic_setup()
    vim.diagnostic.config({
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "●",
                [vim.diagnostic.severity.WARN] = "●",
                [vim.diagnostic.severity.HINT] = "●",
                [vim.diagnostic.severity.INFO] = "●",
            },
        },

    })
end

return M

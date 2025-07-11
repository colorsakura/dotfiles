return {
    {
        "neovim/nvim-lspconfig",
        lazy = true,
        event = { "VeryLazy" },
        dependencies = {
            "mason.nvim",
            "mason-org/mason-lspconfig.nvim",
        },
        opts = function()
            local icons = Core.config.icons
            local ret = {
                ---@type vim.diagnostic.Opts
                diagnostics = {
                    underline = true,
                    update_in_insert = false,
                    -- virtual_lines = {
                    --     current_line = false,
                    -- },
                    virtual_text = {
                        current_line = true,
                    },
                    severity_sort = true,
                    signs = {
                        text = {
                            [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
                            [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
                            [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
                            [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
                        },
                    },
                },
                inlay_hints = {
                    enabled = false,
                    exclude = {},
                },
                codelens = {
                    enabled = false,
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
            Editor.on_very_lazy(function() Snacks.toggle.diagnostics():map "<leader>ud" end)

            Editor.lsp.setup()

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
                        local icons = Core.config.icons.diagnostics
                        for d, icon in pairs(icons) do
                            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then return icon end
                        end
                    end
            end

            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

            local servers = opts.servers
            local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            local has_blink, blink = pcall(require, "blink.cmp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_nvim_lsp.default_capabilities() or {},
                has_blink and blink.get_lsp_capabilities() or {},
                opts.capabilities or {}
            )

            local have_mason, mlsp = pcall(require, "mason-lspconfig")

            if have_mason then
                ---@diagnostic disable-next-line: missing-fields
                mlsp.setup {
                    automatic_enable = {
                        exclude = {
                            "yamlls",
                        },
                    },
                }
            end
        end,
    },
    -- Mason
    {
        "mason-org/mason.nvim",
        lazy = true,
        cmd = "Mason",
        build = ":MasonUpdate",
        opts_extend = { "ensure_installed" },
        opts = {
            ensure_installed = {
                -- c/cpp
                "clangd",
                "clang-format",
                -- web
                "prettier",
                -- python
                "basedpyright",
                "ruff",
                -- shell
                "rust-analyzer",
                "shfmt",
                -- lua
                "stylua",
                "lua-language-server",
                -- markdown
                "marksman",
                "typos",
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
                border = vim.g.winborder or "single",
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
    -- Goto Preview
    {
        "rmagatti/goto-preview",
        dependencies = { "rmagatti/logger.nvim" },
        lazy = true,
        event = { "LspAttach" },
        config = true,
    },
}

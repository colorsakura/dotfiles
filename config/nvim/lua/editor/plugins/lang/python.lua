return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                ruff = {
                    cmd_env = { RUFF_TRACE = "messages" },
                    init_options = {
                        settings = {
                            logLevel = "error",
                        },
                    },
                    keys = {
                        {
                            "<leader>co",
                            Editor.lsp.action["source.organizeImports"],
                            desc = "Organize Imports",
                        },
                    },
                },
            },
            setup = {
                ["ruff"] = function()
                    Editor.lsp.on_attach(function(client, _)
                        -- Disable hover in favor of Pyright
                        client.server_capabilities.hoverProvider = false
                    end, "ruff")
                end,
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            local servers = { "basedpyright", "ruff" }
            for _, server in ipairs(servers) do
                opts.servers[server] = opts.servers[server] or {}
            end
        end,
    },
    {
        "nvim-neotest/neotest",
        optional = true,
        dependencies = {
            "nvim-neotest/neotest-python",
        },
        opts = {
            adapters = {
                ["neotest-python"] = {
                    -- Here you can specify the settings for the adapter, i.e.
                    runner = "pytest",
                    python = ".venv/bin/python",
                },
            },
        },
    },
    {
        "mfussenegger/nvim-dap",
        optional = true,
        dependencies = {
            "mfussenegger/nvim-dap-python",
            keys = {
                {
                    "<leader>dPt",
                    function() require("dap-python").test_method() end,
                    desc = "Debug Method",
                    ft = "python",
                },
                {
                    "<leader>dPc",
                    function() require("dap-python").test_class() end,
                    desc = "Debug Class",
                    ft = "python",
                },
            },
            config = function()
                if vim.fn.has "win32" == 1 then
                    require("dap-python").setup(Editor.get_pkg_path("debugpy", "/venv/Scripts/pythonw.exe"))
                else
                    require("dap-python").setup(Editor.get_pkg_path("debugpy", "/venv/bin/python"))
                end
            end,
        },
    },
    -- TODO: FzfLua
    {
        "linux-cultist/venv-selector.nvim",
        branch = "regexp", -- Use this branch for the new version
        cmd = "VenvSelect",
        enabled = function() return Editor.has "telescope.nvim" end,
        opts = {
            settings = {
                options = {
                    notify_user_on_venv_activation = true,
                },
            },
        },
        --  Call config for python files and load the cached venv automatically
        ft = "python",
        keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
    },

    {
        "hrsh7th/nvim-cmp",
        optional = true,
        opts = function(_, opts)
            opts.auto_brackets = opts.auto_brackets or {}
            table.insert(opts.auto_brackets, "python")
        end,
    },

    -- Don't mess up DAP adapters provided by nvim-dap-python
    {
        "jay-babu/mason-nvim-dap.nvim",
        optional = true,
        opts = {
            handlers = {
                python = function() end,
            },
        },
    },
}

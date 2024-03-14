return {
	-- TODO: fix diagnostics icons
	{
		"neovim/nvim-lspconfig",
		event = { "Filetype" },
		dependencies = {
			{
				"williamboman/mason.nvim",
				cmd = "Mason",
				config = function()
					require("mason").setup({
						ui = {
							icons = {
								package_installed = "✓",
								package_pending = "➜",
								package_uninstalled = "✗",
							},
						},
					})
				end,
			},
			{
				"williamboman/mason-lspconfig.nvim",
				config = function()
					local lspconfig = require "lspconfig"

					require("mason-lspconfig").setup({
						handlers = {
							function(server_name)
								require("lspconfig")[server_name].setup({})
							end,

							lua_ls = function()
								lspconfig.lua_ls.setup {
									on_attach = function(client, bufnr)
										client.server_capabilities.documentFormattingProvider = true
									end,
									before_init = function(...)
										require("neodev.lsp").before_init(...)
									end,
									settings = {
										Lua = {
											runtime = {
												version = "LuaJIT",
											},
											hint = {
												enable = true,
												setType = true,
											},
											codeLens = {
												enable = true,
											},
											completion = {
												callSnippet = "Replace",
												postfix = ".",
												showWord = "Disable",
												workspaceWord = false,
											},
										},
									},
								}
							end,

							gopls = function()
								lspconfig.gopls.setup {
									on_attach = function(client, bufnr)
										client.server_capabilities.documentFormattingProvider = true
									end,
									settings = {
										gopls = {
											hints = {
												assignVariableTypes = true,
												compositeLiteralFields = true,
												compositeLiteralTypes = true,
												constantValues = true,
												functionTypeParameters = true,
												parameterNames = true,
												rangeVariableTypes = true,
											},
										},
									},
								}
							end,
						}
					})
				end,
			},
			{
				"folke/neoconf.nvim",
			},
			{
				"folke/neodev.nvim",
				opts = {
					library = {
						types = false,
						plugins = false,
					},
					lspconfig = false,
				},
				config = function(_, opts)
					require("neodev").setup(opts)
				end,
			},
		},
		config = function()
			-- Diagnostic Sings
			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			do -- disable lsp watcher. Too slow on linux
				local watchfiles = require 'vim.lsp._watchfiles'
				watchfiles._watchfunc = function() return function() end end
			end

			-- Do not log the LSP
			vim.lsp.set_log_level(vim.lsp.log_levels.OFF)
		end,
	},
}

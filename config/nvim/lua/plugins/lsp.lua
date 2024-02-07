return {
	-- TODO: fix diagnostics icons
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			-- Diagnostic Sings
			local signs = { Error = "", Warn = "", Hint = "", Info = "" }
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


			-- inlay_hint
			function inlay_hints(buf, value)
				local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
				if type(ih) == "function" then
					ih(buf, value)
				elseif type(ih) == "table" and ih.enable then
					if value == nil then
						value = not ih.is_enabled(buf)
					end
					ih.enable(buf, value)
				end
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local buffer = args.buf ---@type number
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client.supports_method("textDocument/inlayHint") then
						inlay_hints(buffer, true)
					end
				end,
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("mason").setup()
			local masonlsp = require("mason-lspconfig")
			masonlsp.setup {
				ensure_installed = { "lua_ls", "zls", "gopls", "rust_analyzer", "pyright" },
			}

			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			masonlsp.setup_handlers {
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities
					})
				end,
			}
		end,
	},
}

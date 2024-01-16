local icons = require("utils.icons")

local sign = function(opts)
	vim.fn.sign_define(opts.name, {
		texthl = opts.name,
		text = opts.text,
		numhl = "",
	})
end

sign({ name = "DiagnosticSignError", text = icons.DiagnosticError })
sign({ name = "DiagnosticSignWarn", text = icons.DiagnosticWarn })
sign({ name = "DiagnosticSignHint", text = icons.DiagnosticHint })
sign({ name = "DiagnosticSignInfo", text = icons.DiagnosticInfo })

vim.diagnostic.config({
	virtual_text = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
	},
})

return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason-lspconfig.nvim",
		},
		cmd = { "Mason" },
		build = ":MasonUpdate",
		opts = {},
		config = function(_, opts)
			require("mason").setup(opts)
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"VonHeikemen/lsp-zero.nvim",
		},
		opts = {},
		config = function()
			local lsp_zero = require("lsp-zero")

			lsp_zero.on_attach(function(client, bufnr)
				-- see :help lsp-zero-keybindings
				-- to learn the available actions
				lsp_zero.default_keymaps({ buffer = bufnr })
			end)

			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = {},
				handlers = {
					lsp_zero.default_setup,
				},
			})
		end,
	},
}

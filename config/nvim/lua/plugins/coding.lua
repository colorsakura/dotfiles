return {
	{
		"nvim-cmp",
		opts = {
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
					-- icon
					local icons = require("lazyvim.config").icons.kinds
					vim_item.kind = string.format("%s", icons[vim_item.kind]) or ""
					-- source
					vim_item.menu = ({
						buffer = "BUF",
						codeium = "AI",
						nvim_lsp = "LSP",
						luasnip = "SNP",
						nvim_lua = "LUA",
						latex_symbols = "TEX",
					})[entry.source.name]
					return vim_item
				end,
			},
		},
	},
	{
		"nvim-cmp",
		dependencies = {
			-- codeium
			{
				"Exafunction/codeium.nvim",
				cmd = "Codeium",
				opts = {},
			},
		},
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			table.insert(opts.sources, 1, {
				name = "codeium",
				group_index = 1,
				priority = 100,
				max_item_count = 1,
			})
		end,
	},
	-- Lsp rename
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = true,
	},
}

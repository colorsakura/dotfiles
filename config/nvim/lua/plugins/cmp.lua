return {
	-- TODO: cmp need to setup.
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			{ 'f3fora/cmp-spell' },
			{ 'hrsh7th/cmp-buffer' },
			{ 'hrsh7th/cmp-cmdline' },
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'hrsh7th/cmp-nvim-lua' },
			{ 'hrsh7th/cmp-path' },
			{ 'petertriho/cmp-git' },
			{
				'saadparwaiz1/cmp_luasnip',
				dependencies = {
					'L3MON4D3/LuaSnip',
					dependencies = 'rafamadriz/friendly-snippets',
					config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
				},
			},
		},
		event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local cmp_kinds = {
				Text = '',
				Method = '',
				Function = '',
				Constructor = '',
				Field = '',
				Variable = '',
				Class = '',
				Interface = '',
				Module = '',
				Property = '',
				Unit = '',
				Value = '',
				Enum = '',
				Keyword = '',
				Snippet = '',
				Color = '',
				File = '',
				Reference = '',
				Folder = '',
				EnumMember = '',
				Constant = '',
				Struct = '',
				Event = '',
				Operator = '',
				TypeParameter = '',
			}

			if not vim.fn.has "nvim-0.10" then
				vim.snippet = {
					expand = luasnip.lsp_expand,
					jump = luasnip.jump,
					jumpable = luasnip.jumpable
				}
			end

			cmp.setup({
				snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
				mapping = cmp.mapping.preset.insert(),
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(_, vim_item)
						vim_item.kind = cmp_kinds[vim_item.kind] or ""
						return vim_item
					end,
				},

				experimental = {
					ghost_text = {
						hl_group = "LspInlayHint",
					},
				},

				-- TODO: should add more sources.
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'nvim_lua' },
					{ name = 'luasnip' },
					{ name = 'path' },
					{ name = 'spell' },
				}, {
					{ name = 'buffer' },
				}),
			})

			-- Set configuration for specific filetype.
			cmp.setup.filetype('gitcommit', {
				sources = cmp.config.sources({
					{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
				}, {
					{ name = 'buffer' },
				})
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ '/', '?' }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'buffer' }
				}
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				formatting = {
					fields = { "abbr" },
				},
				sources = cmp.config.sources({
					{ name = 'path' }
				}, {
					{ name = 'cmdline' }
				})
			})
		end,
	},
}

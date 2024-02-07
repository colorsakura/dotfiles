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

			local function cursor_on_word()
				local col = vim.api.nvim_win_get_cursor(0)[2]
				return col ~= 0 and vim.api.nvim_get_current_line():sub(col, col):find '%s' == nil
			end


			if not vim.fn.has "nvim-0.10" then
				local luasnip = require 'luasnip'
				vim.snippet = {
					expand = luasnip.lsp_expand,
					jump = luasnip.jump,
					jumpable = luasnip.jumpable
				}
			end

			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
				mapping = {
					["<Tab>"] = cmp.mapping(function(fallback)
						if not cmp.select_next_item() then
							if cursor_on_word() then
								cmp.complete()
							elseif vim.snippet.jumpable(1) then
								vim.snippet.jump(1)
							else
								fallback()
							end
						end
					end, { 'i', 's' }),

				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(_, vim_item)
						vim_item.kind = cmp_kinds[vim_item.kind] or ""
						return vim_item
					end,
				},
				window = {
					-- completion = { border = 'rounded', winhighlight = 'CursorLine:PmenuSel,Search:None' },
					-- documentation = { border = 'rounded', winhighlight = '' },
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
					{ name = 'path' },
					{ name = 'luasnip' },
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
			-- FIXME: should disable icons before command.
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

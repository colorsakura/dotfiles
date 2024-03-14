return {
	'nvimdev/dashboard-nvim',
	event = 'VimEnter',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		require('dashboard').setup {
			theme = 'doom',
			config = {
				center = {
					{
						icon = '',
						desc = 'File Explore',
						key = 'Ctrl n',
						action = '<C-N>'
					},
					{
						icon = '',
						desc = 'Quit Neovim',
						key = 'q',
						action = 'qa'
					}
				},
				footer = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					return { "⚡ Neovim loaded " ..
					stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
				end,
			}
		}
	end,
}

return {
	-- TODO: dashboard need to setup
	'nvimdev/dashboard-nvim',
	event = 'VimEnter',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		require('dashboard').setup {
			-- config
		}
	end,
}

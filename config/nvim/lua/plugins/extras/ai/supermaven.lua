return {
	{
		"supermaven-inc/supermaven-nvim",
		lazy = true,
		opts = {
			keymaps = {
				accept_suggestion = nil, -- handled by nvim-cmp / blink.cmp
			},
			ignore_filetypes = { "bigfile" },
			disable_inline_completion = true,
		},
	},
	{
		"saghen/blink.cmp",
		optional = true,
		dependencies = { "supermaven-nvim", "saghen/blink.compat" },
		opts = {
			sources = {
				compat = { "supermaven" },
				providers = {
					supermaven = {
						kind = "Supermaven"
					}
				},
			},
		},
	},
}

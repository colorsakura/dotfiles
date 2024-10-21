return {
  {
    "akinsho/toggleterm.nvim",
    events = { "VeryLazy" },
    opts = {
      open_mapping = [[<c-\>]],
    },
    config = function(_, opts) require("toggleterm").setup(opts) end,
  },
	{
		"lilydjwg/fcitx.vim",
		lazy = false
	}
}

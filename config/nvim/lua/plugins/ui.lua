return {
	-- Noice
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},
	-- Notify
	{
		"rcarriga/nvim-notify",
		opts = {
			render = "wrapped-compact",
		},
		config = function(_, opts) require("notify").setup(opts) end,
	},
	-- Todo
	{
		"folke/todo-comments.nvim",
		event = { "VeryLazy" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	-- Improve the default `vim.ui` interfaces
	{
		"stevearc/dressing.nvim",
		event = { "VeryLazy" },
		lazy = true,
		opts = {
			input = {
				insert_only = false,
				win_options = { winblend = 0 },
				mappings = {
					n = {
						["<Esc>"] = "Close",
						["<CR>"] = "Confirm",
					},
					i = {
						["<CR>"] = "Confirm",
						["<C-k>"] = "HistoryPrev",
						["<C-j>"] = "HistoryNext",
					},
				},
			},
			select = {
				get_config = function(opts)
					if opts.kind == "codeaction" then
						return {
							backend = "telescope",
							telescope = require("telescope.themes").get_cursor {
								-- initial_mode = "normal",
								layout_config = { height = 15 },
							},
						}
					end

					return { backend = "telescope", telescope = nil }
				end,
			},
		},
	},
	-- Gitsigns
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		lazy = true,
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local opts = { buffer = bufnr }
				vim.keymap.set({ "n", "v" }, "<leader>gs", gs.stage_hunk, opts)
				vim.keymap.set("n", "<leader>gS", gs.stage_buffer, opts)
				vim.keymap.set("n", "<leader>gl", gs.undo_stage_hunk, opts)

				vim.keymap.set({ "n", "v" }, "<leader>gr", gs.reset_hunk, opts)
				vim.keymap.set("n", "<leader>gR", gs.reset_buffer, opts)

				vim.keymap.set("n", "<leader>gp", gs.preview_hunk, opts)
				vim.keymap.set(
					"n",
					"<leader>gb",
					function() gs.blame_line { full = true } end,
					opts
				)

				vim.keymap.set("n", "<leader>gd", gs.diffthis, opts)
				vim.keymap.set("n", "<leader>gD", function() gs.diffthis "~" end, opts)

				opts = { expr = true, buffer = bufnr }
				vim.keymap.set("n", "[[", function()
					if vim.wo.diff then return "[[" end
					vim.schedule(function() gs.prev_hunk() end)
					return "<Ignore>"
				end, opts)

				vim.keymap.set("n", "]]", function()
					if vim.wo.diff then return "]]" end
					vim.schedule(function() gs.next_hunk() end)
					return "<Ignore>"
				end, opts)
			end,
		},
	},
	-- Yazi
	{
		"mikavilpas/yazi.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = true,
		keys = {
			{
				"<leader>y",
				function() require("yazi").yazi() end,
			},
		},
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		enable = false,
		event = "LspAttach", -- Or `LspAttach`
		config = function()
			require("tiny-inline-diagnostic").setup {
				signs = {
					left = "",
					right = "",
					diag = "●",
					arrow = "    ",
					up_arrow = "    ",
					vertical = " │",
					vertical_end = " └",
				},
			}
		end,
	},
	{ "nvchad/volt" },
	{ "nvchad/showkeys" },
	{
		"NvChad/nvim-colorizer.lua",
		ft = { "css", "json" },
		opts = {
			filetypes = { "*" },
			user_default_options = {
				RGB = true,          -- #RGB hex codes
				RRGGBB = true,       -- #RRGGBB hex codes
				names = true,        -- "Name" codes like Blue or blue
				RRGGBBAA = false,    -- #RRGGBBAA hex codes
				AARRGGBB = false,    -- 0xAARRGGBB hex codes
				rgb_fn = true,       -- CSS rgb() and rgba() functions
				hsl_fn = false,      -- CSS hsl() and hsla() functions
				css = true,          -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true,       -- Enable all CSS *functions*: rgb_fn, hsl_fn
				-- Available modes for `mode`: foreground, background,  virtualtext
				mode = "background", -- Set the display mode.
				-- Available methods are false / true / "normal" / "lsp" / "both"
				-- True is same as normal
				tailwind = false,                               -- Enable tailwind colors
				-- parsers can contain values used in |user_default_options|
				sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
				virtualtext = "■ ",
				-- update color values even if buffer is not focused
				-- example use: cmp_menu, cmp_docs
				always_update = false,
			},
			-- all the sub-options of filetypes apply to buftypes
			buftypes = {},
		},
		config = function(_, opts) require("colorizer").setup(opts) end,
	},
}

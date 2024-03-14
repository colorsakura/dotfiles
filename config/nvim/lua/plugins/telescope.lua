return {
	{
		"nvim-telescope/telescope.nvim",
		version = false,
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build =
				'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
			},
			{
				"FeiyouG/commander.nvim",
				config = function()
					require("commander").setup()
				end,
			},
		},
		opts = function()
			local actions = require("telescope.actions")
			return {
				defaults = {
					-- layout_strategy = "center",
					layout_config = {
					},
					preview = false, -- 禁用预览窗口
					mappings = {
						i = {
							["<esc>"] = actions.close
						},
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,             -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					}
				}
			}
		end,
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			telescope.load_extension('fzf')
			telescope.load_extension('commander')
			-- telescope.load_extension('projects')
		end
	},
	-- {
	-- 	"ahmedkhalf/project.nvim",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		require("project_nvim").setup()
	-- 	end,
	-- },
}

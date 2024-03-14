return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	cmd = "Neotree",
	init = function()
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("load_neo_tree", {}),
			desc = "Loads neo-tree when openning a directory",
			callback = function(args)
				local stats = vim.uv.fs_stat(args.file)

				if not stats or stats.type ~= "directory" then
					return
				end

				require "neo-tree"

				return true
			end,
		})
	end,
	opts = {
		source_selector = {
			winbar = true,
			sources = {
				{
					source = "filesystem",
					display_name = "  ",
				},
				{
					source = "buffers",
					display_name = "  ",
				{
					source = "git_status",
				},
					display_name = "  ",
				},
				{
					source = "document_symbols",
					display_name = "  ",
				},
			},
		},
		close_if_last_window = true,
		commands = {
			parent_or_close = function(state)
				local node = state.tree:get_node()
				if (node.type == "directory" or node:has_children()) and node:is_expanded() then
					state.commands.toggle_node(state)
				else
					require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
				end
			end,
			child_or_open = function(state)
				local node = state.tree:get_node()
				if node.type == "directory" or node:has_children() then
					if not node:is_expanded() then -- if unexpanded, expand
						state.commands.toggle_node(state)
					else                      -- if expanded and has children, seleect the next child
						require("neo-tree.ui.renderer").focus_node(state,
							node:get_child_ids()
							[1])
					end
				else -- if not a directory just open it
					state.commands.open(state)
				end
			end,
		},
		window = {
			width = 26,
			mappings = {
				h = "parent_or_close",
				l = "child_or_open",
			}
		},
		filtered_items = {
			visible = false, -- when true, they will just be displayed differently than normal items
			hide_dotfiles = true,
			hide_gitignored = true,
			hide_hidden = true, -- only works on Windows for hidden files/directories
			hide_by_name = {
				-- "node_modules",
			},
			hide_by_pattern = { -- uses glob style patterns
				--"*.meta",
				--"*/src/*/tsconfig.json",
			},
			always_show = { -- remains visible even if other settings would normally hide it
				--".gitignored",
				".github/",
			},
			never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
				--".DS_Store",
				--"thumbs.db"
			},
			never_show_by_pattern = { -- uses glob style patterns
				--".null-ls_*",
			},
		},
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)
		vim.api.nvim_create_augroup("load_neo_tree", {})
	end,
}

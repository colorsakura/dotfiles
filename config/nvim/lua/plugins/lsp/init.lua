return {
	{
		"neovim/nvim-lspconfig",
		event = { "LazyFile" },
		dependencies = {
			{
				"williamboman/mason.nvim",
			},
			{
				"williamboman/mason-lspconfig.nvim",
				config = function() end,
			},
		},
		opts = function()
			local ret = {
				-- options for vim.diagnostic.config()
				---@type vim.diagnostic.Opts
				diagnostics = {
					underline = true,
					update_in_insert = false,
					virtual_text = {
						spacing = 4,
						source = "if_many",
						prefix = "●",
						-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
						-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
						-- prefix = "icons",
					},
					severity_sort = true,
					signs = {
						text = {
							[vim.diagnostic.severity.ERROR] = Editor.config.icons.diagnostics.Error,
							[vim.diagnostic.severity.WARN] = Editor.config.icons.diagnostics.Warn,
							[vim.diagnostic.severity.HINT] = Editor.config.icons.diagnostics.Hint,
							[vim.diagnostic.severity.INFO] = Editor.config.icons.diagnostics.Info,
						},
					},
				},
				-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
				-- Be aware that you also will need to properly configure your LSP server to
				-- provide the inlay hints.
				inlay_hints = {
					enabled = true,
					exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
				},
				-- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
				-- Be aware that you also will need to properly configure your LSP server to
				-- provide the code lenses.
				codelens = {
					enabled = false,
				},
				-- Enable lsp cursor word highlighting
				document_highlight = {
					enabled = true,
				},
				-- add any global capabilities here
				capabilities = {
					workspace = {
						fileOperations = {
							didRename = true,
							willRename = true,
						},
					},
				},
				-- options for vim.lsp.buf.format
				-- `bufnr` and `filter` is handled by the LazyVim formatter,
				-- but can be also overridden when specified
				format = {
					formatting_options = nil,
					timeout_ms = nil,
				},
				-- LSP Server Settings
				---@type lspconfig.options
				servers = {
					lua_ls = {
						-- mason = false, -- set to false if you don't want this server to be installed with mason
						-- Use this to add any additional keymaps
						-- for specific lsp servers
						-- ---@type LazyKeysSpec[]
						-- keys = {},
						settings = {
							Lua = {
								workspace = {
									checkThirdParty = false,
								},
								codeLens = {
									enable = true,
								},
								completion = {
									callSnippet = "Replace",
								},
								doc = {
									privateName = { "^_" },
								},
								hint = {
									enable = true,
									setType = false,
									paramType = true,
									paramName = "Disable",
									semicolon = "Disable",
									arrayIndex = "Disable",
								},
							},
						},
					},
				},
				-- you can do any additional lsp server setup here
				-- return true if you don't want this server to be setup with lspconfig
				---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
				setup = {
					-- example to setup with typescript.nvim
					-- tsserver = function(_, opts)
					--   require("typescript").setup({ server = opts })
					--   return true
					-- end,
					-- Specify * to use this function as a fallback for any server
					-- ["*"] = function(server, opts) end,
				},
			}
			return ret
		end,
		config = function(_, opts)
			-- lsp keymaps
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local buf = event.buffer

					vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { buffer = buf, desc = "Hover" })
					vim.keymap.set(
						"n",
						"grd",
						"<cmd>lua vim.lsp.buf.definition()<cr>",
						{ buffer = buf, desc = "Goto Definition" }
					)
					vim.keymap.set(
						"n",
						"grD",
						"<cmd>lua vim.lsp.buf.declaration()<cr>",
						{ buffer = buf, desc = "Goto Declaration" }
					)
					vim.keymap.set(
						"n",
						"gri",
						"<cmd>lua vim.lsp.buf.implementation()<cr>",
						{ buffer = buf, desc = "Goto Implementation" }
					)
					vim.keymap.set("n", "gro", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { buffer = buf })
					vim.keymap.set("n", "grr", "<cmd>lua vim.lsp.buf.references()<cr>", { buffer = buf })
					vim.keymap.set("n", "grs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { buffer = buf })
					vim.keymap.set("n", "grn", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = buf, desc = "Code Rename" })
					vim.keymap.set(
						{ "n", "x" },
						"grf",
						"<cmd>lua vim.lsp.buf.format({async = true})<cr>",
						{ buffer = buf, desc = "Code Format" }
					)
					vim.keymap.set("n", "gra", "<cmd>lua vim.lsp.buf.code_action()<cr>", { buffer = buf, desc = "Code Action" })
				end,
			})

			-- diagnostics signs
				if type(opts.diagnostics.signs) ~= "boolean" then
					for severity, icon in pairs(opts.diagnostics.signs.text) do
						local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
						name = "DiagnosticSign" .. name
						vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
					end
				end

			if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
				opts.diagnostics.virtual_text.prefix = vim.fn.has "nvim-0.10.0" == 0 and "●"
						or function(diagnostic)
							local icons = Editor.config.icons.diagnostics
							for d, icon in pairs(icons) do
								if diagnostic.severity == vim.diagnostic.severity[d:upper()] then return icon end
							end
						end
			end

			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			local servers = opts.servers
			local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			local has_blink, blink = pcall(require, "blink.cmp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				has_cmp and cmp_nvim_lsp.default_capabilities() or {},
				has_blink and blink.get_lsp_capabilities() or {},
				opts.capabilities or {}
			)

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})
				if server_opts.enabled == false then return end

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then return end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then return end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			-- get all the servers that are available through mason-lspconfig
			local have_mason, mlsp = pcall(require, "mason-lspconfig")
			local all_mslp_servers = {}
			if have_mason then
				all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
			end

			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					if server_opts.enabled ~= false then
						if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
							setup(server)
						else
							ensure_installed[#ensure_installed + 1] = server
						end
					end
				end
			end

			if have_mason then
				mlsp.setup {
					handlers = { setup },
				}
			end
		end,
	},
	-- Mason
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
			},
			pip = {
				upgrade_pip = true,
			},
			ui = {
				icons = {
					package_installed = "●",
					package_pending = "●",
					package_uninstalled = "○",
				},
				border = vim.g.border or "none",
				width = 0.65,
				height = 0.65,
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require "mason-registry"
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger {
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					}
				end, 100)
			end)

			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then p:install() end
				end
			end)
		end,
	},
	-- Neovim dev
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
}

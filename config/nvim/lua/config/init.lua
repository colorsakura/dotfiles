_G.Editor = require "util"

local M = {}

Editor.config = M

local defaults = {
  -- colorscheme can be a string like `catppuccin` or a function that will load the colorscheme
  ---@type string|fun()
  colorscheme = function() require("catppuccin").load() end,
	-- icons used by other plugins
	-- stylua: ignore
	icons = {
		misc = {
			dots = "󰇘",
		},
		ft = {
			octo = "",
		},
		dap = {
			Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
			Breakpoint          = " ",
			BreakpointCondition = " ",
			BreakpointRejected  = { " ", "DiagnosticError" },
			LogPoint            = ".>",
		},
		diagnostics = {
			Error = " ",
			Warn  = " ",
			Hint  = " ",
			Info  = " ",
		},
		git = {
			added    = " ",
			modified = " ",
			removed  = " ",
		},
		kinds = {
			Array         = " ",
			Boolean       = "󰨙 ",
			Class         = " ",
			Codeium       = "󰘦 ",
			Color         = " ",
			Control       = " ",
			Collapsed     = " ",
			Constant      = "󰏿 ",
			Constructor   = " ",
			Copilot       = " ",
			Enum          = " ",
			EnumMember    = " ",
			Event         = " ",
			Field         = " ",
			File          = " ",
			Folder        = " ",
			Function      = "󰊕 ",
			Interface     = " ",
			Key           = " ",
			Keyword       = " ",
			Method        = "󰊕 ",
			Module        = " ",
			Namespace     = "󰦮 ",
			Null          = " ",
			Number        = "󰎠 ",
			Object        = " ",
			Operator      = " ",
			Package       = " ",
			Property      = " ",
			Reference     = " ",
			Snippet       = " ",
			String        = " ",
			Struct        = "󰆼 ",
			Supermaven    = " ",
			TabNine       = "󰏚 ",
			Text          = " ",
			TypeParameter = " ",
			Unit          = " ",
			Value         = " ",
			Variable      = "󰀫 ",
		},
	},
  ---@type table<string, string[]|boolean>?
  kind_filter = {
    default = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      "Package",
      "Property",
      "Struct",
      "Trait",
    },
    markdown = false,
    help = false,
    -- you can specify a different filter for each filetype
    lua = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      -- "Package", -- remove package since luals uses it for control flow structures
      "Property",
      "Struct",
      "Trait",
    },
  },
}

local options

function M.setup(opts)
  options = vim.tbl_deep_extend("force", defaults, opts or {}) or {}

  -- autocmds can be loaded lazily when not opening a file
  local lazy_autocmds = vim.fn.argc(-1) == 0
  if not lazy_autocmds then M.load "autocmds" end
  M.load "keymaps"

  local group = vim.api.nvim_create_augroup("Editor", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "VeryLazy",
    callback = function()
      if lazy_autocmds then M.load "autocmds" end
      M.load "keymaps"
    end,
  })

  require("lazy").setup {
    spec = {
      { import = "plugins" },
    },
    defaults = {
      -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
      -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
      lazy = false,
      -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
      -- have outdated releases, which may break your Neovim install.
      version = false, -- always use the latest git commit
      -- version = "*", -- try installing the latest stable version for plugins that support semver
    },
    install = { colorscheme = { "tokyonight", "habamax" } },
    checker = {
      enabled = true, -- check for plugin updates periodically
      notify = false, -- notify on update
    }, -- automatically check for plugin updates
    performance = {
      rtp = {
        -- disable some rtp plugins
        disabled_plugins = {
          "gzip",
          -- "matchit",
          -- "matchparen",
          -- "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  }
  Editor.track "colorscheme"
  Editor.try(function()
    if type(M.colorscheme) == "function" then
      M.colorscheme()
    else
      vim.cmd.colorscheme(M.colorscheme)
    end
  end, {
    msg = "Could not load your colorscheme",
    on_error = function(msg)
      Editor.error(msg)
      vim.cmd.colorscheme "habamax"
    end,
  })
  Editor.track()
end

M.did_init = false
function M.init()
  if M.did_init then return end
  M.did_init = true

  M.load "options"

  Editor.plugin.setup()
end

function M.load(name)
  local function _load(mod)
    if require("lazy.core.cache").find(mod)[1] then
      Editor.try(function() require(mod) end, { msg = "Failed loading " .. mod })
    end
  end
  _load("config." .. name)
end

setmetatable(M, {
  __index = function(_, key)
    if options == nil then return vim.deepcopy(defaults)[key] end
    return options[key]
  end,
})

return M

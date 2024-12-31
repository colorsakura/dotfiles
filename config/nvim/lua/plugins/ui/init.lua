return {
  {
    "rebelot/heirline.nvim",
    dependencies = { "zeioth/heirline-components.nvim" },
    event = "VeryLazy",
    opts = function()
      local lib = require "heirline-components.all"
      local stausline = require "plugins.ui.components.statusline"
      local winbar = require "plugins.ui.components.winbar"
      return {
        opts = {
          disable_winbar_cb = function(args) -- We do this to avoid showing it on the greeter.
            local is_disabled = not require("heirline-components.buffer").is_valid(args.buf)
              or lib.condition.buffer_matches({
                buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
                filetype = { "NvimTree", "neo%-tree", "dashboard", "Outline", "aerial" },
              }, args.buf)
            return is_disabled
          end,
        },
        tabline = { -- UI upper bar
          -- lib.component.tabline_conditional_padding(),
          lib.component.tabline_buffers {},
          lib.component.fill { hl = { bg = "tabline_bg" } },
          lib.component.tabline_tabpages(),
        },
        winbar = { -- UI breadcrumbs bar
          init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
          fallthrough = false,
          -- Winbar for terminal, neotree, and aerial.
          {
            condition = function() return not lib.condition.is_active() end,
            {
              lib.component.neotree(),
              lib.component.fill(),
              lib.component.aerial(),
            },
          },
          -- Regular winbar
          {
            lib.component.neotree(),
            winbar.filename(),
            lib.component.breadcrumbs(),
            lib.component.fill(),
            lib.component.aerial(),
          },
        },
        -- statuscolumn = { -- UI left column
        --   init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
        --   lib.component.foldcolumn(),
        --   lib.component.numbercolumn(),
        --   lib.component.signcolumn(),
        -- } or nil,
        statusline = { -- UI statusbar
          hl = { fg = "fg", bg = "bg" },
          lib.component.mode(),
          lib.component.git_branch(),
          lib.component.diagnostics(),
          lib.component.fill(),
          lib.component.nav(),
          -- lib.component.git_diff(),
          lib.component.lsp(),
          -- lib.component.virtual_env(),
          -- lib.component.file_info(),
          stausline.file_info(),
          lib.component.mode { surround = { separator = "right" } },
        },
      }
    end,
    config = function(_, opts)
      local heirline = require "heirline"
      local heirline_components = require "heirline-components.all"

      -- Setup
      heirline_components.init.subscribe_to_events()
      heirline.load_colors(heirline_components.hl.get_colors())
      heirline.setup(opts)
    end,
  },
  {
    "stevearc/aerial.nvim",
    event = "VeryLazy",
    opts = function()
      local icons = vim.deepcopy(Editor.config.icons.kinds)

      -- HACK: fix lua's weird choice for `Package` for control
      -- structures like if/else/for/etc.
      icons.lua = { Package = icons.Control }

      ---@type table<string, string[]>|false
      local filter_kind = false
      if Editor.config.kind_filter then
        filter_kind = assert(vim.deepcopy(Editor.config.kind_filter))
        filter_kind._ = filter_kind.default
        filter_kind.default = nil
      end

      local opts = {
        -- attach_mode = "global",
        backends = { "lsp", "treesitter", "markdown", "man" },
        show_guides = true,
        layout = {
          resize_to_content = true,
          win_opts = {
            winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
            signcolumn = "yes",
            statuscolumn = " ",
          },
          placement = "edge",
        },
        icons = icons,
        filter_kind = filter_kind,
        highlight_on_hover = true,
        -- stylua: ignore
        guides = {
          mid_item   = "├╴",
          last_item  = "└╴",
          nested_top = "│ ",
          whitespace = "  ",
        },
      }

      return opts
    end,
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>ca", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
    },
    config = function(_, opts) require("aerial").setup(opts) end,
  },
  -- icons
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢 ", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = " ", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = " ", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true, events = "VeryLazy" },
  {
    "stevearc/dressing.nvim",
    lazy = true,
    events = "VeryLazy",
    opts = {
      select = {
        backend = { "fzf_lua" },
      },
    },
    config = function(_, opts) require("dressing").setup(opts) end,
  },
  -- dashboard
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },
  -- snacks
  {
    "folke/snacks.nvim",
    opts = function()
      Snacks.config.style("notification", {
        border = vim.g.border or "single",
      })
    end,
  },
  -- catppuccin support for blink
  {
    "catppuccin",
    optional = true,
    opts = {
      integrations = { blink_cmp = true },
    },
  },
  -- visual mode, show char
  {
    "mcauley-penney/visual-whitespace.nvim",
    lazy = true,
    event = "LazyFile",
    config = true,
  },
}

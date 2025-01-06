return {
  -- TODO: 当heirline的bufferline能正常显示后，移除
  -- This is what powers LazyVim's fancy-looking
  -- tabs, which include filetype icons and close buttons.
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) Snacks.bufdelete(n) end,
        -- stylua: ignore
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = Editor.config.icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
        ---@param opts bufferline.IconFetcherOpts
        get_element_icon = function(opts) return Editor.config.icons.ft[opts.filetype] end,
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function() pcall(nvim_bufferline) end)
        end,
      })
    end,
  },
  {
    "rebelot/heirline.nvim",
    dependencies = { "zeioth/heirline-components.nvim" },
    event = "VeryLazy",
    opts = function()
      local lib = require "heirline-components.all"
      local mylib = require "plugins.ui.components"

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
          lib.component.tabline_conditional_padding(),
          lib.component.tabline_buffers {},
          lib.component.fill { hl = { bg = "tabline_bg" } },
          lib.component.tabline_tabpages(),
        },
        winbar = { -- UI breadcrumbs bar
          init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
          fallthrough = false,
          hl = { bg = "bg" },
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
            mylib.filename(),
            lib.component.breadcrumbs { hl = { bg = "bg" } },
            -- mylib.breadcrumbs(),
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
        statusline = {
          init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
          fallthrough = false,
          {
            condition = function() return vim.bo.filetype == "toggleterm" end,
            {
              hl = { fg = "fg", bg = "bg" },
              lib.component.mode(),
              lib.component.fill(),
              lib.component.mode { surround = { separator = "right" } },
            },
          },
          { -- UI statusbar
            hl = { fg = "fg", bg = "bg" },
            lib.component.mode(),
            lib.component.git_branch(),
            lib.component.git_diff(),
            lib.component.diagnostics(),
            lib.component.fill(),
            lib.component.nav(),
            lib.component.lsp(),
            mylib.file_info(),
            lib.component.mode { surround = { separator = "right" } },
          },
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
          win_opts = {
            winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
            signcolumn = "no",
            statuscolumn = "",
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

      Snacks.config.style("notification_history", {
        width = 0.8,
        height = 0.8,
      })
    end,
  },
  -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      notify = { enabled = false },
      popupmenu = { enabled = false },
      lsp = {
        progress = {
          enabled = false,
        },
        hover = { enabled = false },
        signature = { enabled = false },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>sn", "", desc = "+noice"},
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then vim.cmd [[messages clear]] end
      require("noice").setup(opts)
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

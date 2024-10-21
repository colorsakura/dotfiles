return {
  -- Noice
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
        dependencies = {
          -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
          "MunifTanjim/nui.nvim",
          -- OPTIONAL:
          --   `nvim-notify` is only needed, if you want to use the notification view.
          --   If not available, we use `mini` as the fallback
          "rcarriga/nvim-notify",
        },
        config = {},
      },
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
    event = { "BufEnter" },
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
  -- Menu
  -- TODO:
  {
    "nvchad/menu",
    event = { "VeryLazy" },
    config = function()
      local menu = {
        {
          name = "Goto Definition",
          cmd = vim.lsp.buf.definition,
          rtxt = "gd",
        },
        {
          name = "Goto Declaration",
          cmd = vim.lsp.buf.declaration,
          rtxt = "gD",
        },
        {
          name = "Code Actions",
          cmd = vim.lsp.buf.code_action,
          rtxt = "gra",
        },
        { name = "separator" },
        {
          name = "Format Buffer",
          cmd = function()
            local ok, conform = pcall(require, "conform")

            if ok then
              conform.format { lsp_fallback = true }
            else
              vim.lsp.buf.format()
            end
          end,
          rtxt = "grf",
        },

        {
          name = "Edit Config",
          cmd = function()
            vim.cmd "tabnew"
            local conf = vim.fn.stdpath "config"
            vim.cmd("tcd " .. conf .. " | e init.lua")
          end,
          rtxt = "ed",
        },

        {
          name = "Copy Content",
          cmd = "%y+",
          rtxt = "<C-c>",
        },

        {
          name = "Delete Content",
          cmd = "%d",
          rtxt = "dc",
        },

        { name = "separator" },

        {
          name = "  Open in terminal",
          hl = "ExRed",
          cmd = function()
            local old_buf = require("menu.state").old_data.buf
            local old_bufname = vim.api.nvim_buf_get_name(old_buf)
            local old_buf_dir = vim.fn.fnamemodify(old_bufname, ":h")

            local cmd = "cd " .. old_buf_dir

            -- base46_cache var is an indicator of nvui user!
            if vim.g.base46_cache then
              require("nvchad.term").new { cmd = cmd, pos = "sp" }
            else
              vim.cmd "enew"
              vim.fn.termopen { vim.o.shell, "-c", cmd .. " ; " .. vim.o.shell }
            end
          end,
        },
      }

      vim.keymap.set("n", "<RightMouse>", function()
        vim.cmd.exec '"normal! \\<RightMouse>"'

        require("menu").open(menu, { mouse = true, border = true })
      end, {})
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    ft = { "css", "json" },
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = true, -- "Name" codes like Blue or blue
        RRGGBBAA = false, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = false, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode.
        -- Available methods are false / true / "normal" / "lsp" / "both"
        -- True is same as normal
        tailwind = false, -- Enable tailwind colors
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

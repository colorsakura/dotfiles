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
    config = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
    },
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
}

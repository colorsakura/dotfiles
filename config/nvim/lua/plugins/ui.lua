return {
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  -- Completely replaces the UI for messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      { "MunifTanjim/nui.nvim", lazy = true },
      { "rcarriga/nvim-notify", lazy = true, opts = { background_colour = "#000000" } },
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      views = {
        mini = {
          win_options = { winblend = 0 },
        },
      },
    },
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

  -- Quickfix
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    opts = {},
  },

  -- Manage LSP/DAP servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
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
  },

  -- Find and replace with dark power
  -- {
  --   "nvim-pack/nvim-spectre",
  --   dependencies = {
  --     { "nvim-lua/plenary.nvim", lazy = true },
  --   },
  --   keys = {
  --     { "<leader>f", ":lua require('spectre').open()<CR>", mode = "n", silent = true },
  --     { "<leader>f", ":lua require('spectre').open_visual()<CR>", mode = "v", silent = true },
  --   },
  --   opts = {
  --     highlight = {
  --       search = "DiffDelete",
  --       replace = "DiffAdd",
  --     },
  --     mapping = {
  --       ["toggle_line"] = {
  --         map = "<Tab>",
  --         cmd = ":lua require('spectre').toggle_line()<CR>",
  --       },
  --       ["enter_file"] = {
  --         map = "<CR>",
  --         cmd = ":lua require('spectre.actions').select_entry()<CR>",
  --       },
  --       ["send_to_qf"] = { map = "<Nop>" },
  --       ["replace_cmd"] = { map = "<Nop>" },
  --       ["show_option_menu"] = { map = "<Nop>" },
  --       ["run_current_replace"] = {
  --         map = "r",
  --         cmd = ":lua require('spectre.actions').run_current_replace()<CR>",
  --       },
  --       ["run_replace"] = {
  --         map = "R",
  --         cmd = ":lua require('spectre.actions').run_replace()<CR>",
  --       },
  --       ["change_view_mode"] = {
  --         map = "tv",
  --         cmd = ":lua require('spectre').change_view()<CR>",
  --       },
  --       ["change_replace_sed"] = { map = "<Nop>" },
  --       ["change_replace_oxi"] = { map = "<Nop>" },
  --       ["toggle_live_update"] = { map = "<Nop>" },
  --       ["toggle_ignore_case"] = {
  --         map = "tc",
  --         cmd = ":lua require('spectre').change_options('ignore-case')<CR>",
  --       },
  --       ["toggle_ignore_hidden"] = {
  --         map = "th",
  --         cmd = ":lua require('spectre').change_options('hidden')<CR>",
  --       },
  --       ["resume_last_search"] = {
  --         map = "l",
  --         cmd = ":lua require('spectre').resume_last_search()<CR>",
  --       },
  --     },
  --     is_insert_mode = true,
  --   },
  -- },

  -- A pretty list to show diagnostics, references, and quickfix results
  {
    "folke/trouble.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    cmd = { "Trouble" },
    keys = {
      { ",e", ":Trouble diagnostics toggle<CR>", silent = true },
      { ",E", ":Trouble diagnostics toggle filter.buf=0<CR>", silent = true },
      { ",q", ":Trouble qflist toggle<CR>", silent = true },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous { skip_groups = true, jump = true }
          else
            vim.cmd.cprev()
          end
        end,
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next { skip_groups = true, jump = true }
          else
            vim.cmd.cnext()
          end
        end,
      },
    },
    opts = {
      action_keys = {
        previous = "u",
        next = "e",

        jump = "<Tab>",
        jump_close = "<CR>",

        open_split = "s",
        open_vsplit = "S",
        open_tab = "t",

        toggle_fold = "za",
        open_folds = "zr",
        close_folds = "zm",
      },
    },
    config = function(opts)
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "Trouble",
        callback = function(event)
          if require("trouble.config").options.mode ~= "telescope" then return end

          local function delete()
            local folds = require "trouble.folds"
            local telescope = require "trouble.providers.telescope"

            local ord = { "" } -- { filename, ... }
            local files = { [""] = { 1, 1, 0 } } -- { [filename] = { start, end, start_index } }
            for i, result in ipairs(telescope.results) do
              if files[result.filename] == nil then
                local next = files[ord[#ord]][2] + 1
                files[result.filename] = { next, next, i }
                table.insert(ord, result.filename)
              end
              if not folds.is_folded(result.filename) then files[result.filename][2] = files[result.filename][2] + 1 end
            end

            local line = unpack(vim.api.nvim_win_get_cursor(0))
            for i, id in ipairs(ord) do
              if line == files[id][1] then -- Group
                local next = ord[i + 1]
                for _ = files[id][3], next and files[next][3] - 1 or #telescope.results do
                  table.remove(telescope.results, files[id][3])
                end
                break
              elseif line <= files[id][2] then -- Item
                table.remove(telescope.results, files[id][3] + (line - files[id][1]) - 1)
                break
              end
            end

            if #telescope.results == 0 then
              require("trouble").close()
            else
              require("trouble").refresh { provider = "telescope", auto = false }
            end
          end

          vim.keymap.set("n", "x", delete, { buffer = event.buf })
        end,
      })

      require("trouble").setup(opts)
    end,
  },

  -- Git integration for buffers
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
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
        vim.keymap.set("n", "<leader>gb", function() gs.blame_line { full = true } end, opts)

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

  -- Highlighting other uses of the word under the cursor
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "neovim/nvim-lspconfig" },
    keys = { "_", "+" },
    opts = {
      providers = { "lsp", "treesitter", "regex" },
      delay = 200,
      filetypes_denylist = {
        "TelescopePrompt",
        "Trouble",
        "neo-tree",
        "neo-tree-popup",
        "DressingInput",
        "spectre_panel",
        "Outline",
        "checkhealth",
      },
      min_count_to_highlight = 2,
    },
    config = function(_, opts)
      local illuminate = require "illuminate"
      illuminate.configure(opts)

      local function map(buffer)
        vim.keymap.set("n", "_", function() illuminate.goto_next_reference(false) end, { buffer = buffer })
        vim.keymap.set("n", "+", function() illuminate.goto_prev_reference(false) end, { buffer = buffer })
      end

      map(nil)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function() map(vim.api.nvim_get_current_buf()) end,
      })
    end,
  },

  -- Neovim plugin for Yazi
  {
    "mikavilpas/yazi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "VeryLazy" },
    keys = {
      {
        "<leader>y",
        function() require("yazi").yazi() end,
      },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "▏",
      },
      exclude = {
        buftypes = {
          "nofile",
          "prompt",
          "quickfix",
          "terminal",
        },
        filetypes = {
          "aerial",
          "alpha",
          "dashboard",
          "help",
          "lazy",
          "mason",
          "neo-tree",
          "NvimTree",
          "neogitstatus",
          "notify",
          "startify",
          "toggleterm",
          "Trouble",
        },
      },
    },
  },

  -- Dashboard
  {
    "goolord/alpha-nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "echasnovski/mini.icons" },
    },
    config = function()
      local startify = require "alpha.themes.startify"
      -- available: devicons, mini, default is mini
      -- if provider not loaded and enabled is true, it will try to use another provider
      startify.file_icons.provider = "devicons"
      require("alpha").setup(startify.config)
    end,
  },

  -- Tab page
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
      "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
    },
    event = { "VeryLazy" },
    opts = {},
    exclude_ft = { "alpha" },
  },
}

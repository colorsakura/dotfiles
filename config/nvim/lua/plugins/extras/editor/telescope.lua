return {
  -- Fuzz finder
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    event = { "VeryLazy" },
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
      },
      { "nvim-lua/plenary.nvim", lazy = true },
      { "ahmedkhalf/project.nvim" },
    },
    keys = function()
      local extr_args = {
        "--hidden", -- Search hidden files that are prefixed with `.`
        "--no-ignore", -- Don’t respect .gitignore
        "-g",
        "!.cache/",
        "-g",
        "!.git/",
        "-g",
        "!node_modules/",
        "-g",
        "!.venv/",
        "-g",
        "!.idea/",
        "-g",
        "!pnpm-lock.yaml",
        "-g",
        "!package-lock.json",
        "-g",
        "!go.sum",
        "-g",
        "!lazy-lock.json",
        "-g",
        "!.zsh_history",
      }

      return {
        -- Search
        {
          "<leader>f",
          function()
            require("telescope.builtin").find_files {
              layout_config = { width = 0.65 },
            }
          end,
          desc = "File Picker",
        },
        {
          "<leader>F",
          function()
            require("telescope.builtin").find_files {
              layout_config = { width = 0.65 },
              find_command = {
                "rg",
                "--color=never",
                "--smart-case",
                "--files",
                unpack(extr_args),
              },
            }
          end,
          desc = "File Picker(rg)",
        },
        {
          "<leader>/",
          function() require("telescope.builtin").live_grep() end,
          desc = "Live Grep",
        },

        -- Project
        {
          "<leader>pf",
          function() require("telescope").extensions.projects.projects {} end,
          desc = "Project Picker",
        },
      }
    end,
    config = function()
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      local trouble = require "trouble.sources.telescope"

      telescope.setup {
        defaults = {
          scroll_strategy = "limit",
          prompt_prefix = " ",
          selection_caret = " ",
          multi_icon = " ",
          mappings = {
            -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua#L133
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<M-k>"] = actions.preview_scrolling_up,
              ["<M-j>"] = actions.preview_scrolling_down,
              ["<C-s>"] = actions.select_vertical,
              ["<C-h>"] = actions.select_horizontal,
              ["<C-t>"] = actions.select_tab,
            },
            n = {},
          },
          buffer_previewer_maker = function(filepath, bufnr, opts)
            require("plenary.job")
              :new({
                command = "file",
                args = { "-b", "--mime", filepath },
                on_exit = function(j)
                  if j:result()[1]:find("charset=binary", 1, true) then
                    vim.schedule(function() vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" }) end)
                  else
                    require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, opts)
                  end
                end,
              })
              :sync()
          end,
        },
        pickers = {
          find_files = { previewer = false },
          live_grep = { theme = "ivy" },

          lsp_references = { theme = "ivy" },
          lsp_definitions = { theme = "ivy" },
          lsp_type_definitions = { theme = "ivy" },
          lsp_implementations = { theme = "ivy" },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
          },
        },
      }

      telescope.load_extension "projects"
      telescope.load_extension "fzf"
    end,
  },
  -- better vim.ui with telescope
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
  },
}

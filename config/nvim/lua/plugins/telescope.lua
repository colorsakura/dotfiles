return {
  -- Fuzz finder
  {
    "nvim-telescope/telescope.nvim",
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
          function() require("telescope.builtin").find_files() end,
          desc = "Open file picker",
        },
        {
          "<leader>F",
          function()
            require("telescope.builtin").find_files {
              find_command = {
                "rg",
                "--color=never",
                "--smart-case",
                "--files",
                unpack(extr_args),
              },
            }
          end,
        },
        {
          "<leader>/",
          function() require("telescope.builtin").live_grep() end,
          desc = "Live grep",
        },

        -- Project
        {
          "<leader>tp",
          function() require("telescope").extensions.projects.projects {} end,
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
              ["<C-n>"] = false, -- disable default keybinding

              ["<C-k>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.cycle_history_next,
              ["<M-k>"] = actions.preview_scrolling_up,
              ["<M-j>"] = actions.preview_scrolling_down,
              ["<C-s>"] = actions.select_vertical,
              ["<C-h>"] = actions.select_horizontal,
              ["<C-t>"] = actions.select_tab,
              ["<C-q>"] = trouble.open,
            },
            n = {
              ["k"] = false, -- disable default keybinding
              ["<S-Tab>"] = false, -- disable default keybinding

              ["<Tab>"] = actions.toggle_selection,
              ["<BS>"] = actions.delete_buffer,
              ["u"] = actions.move_selection_previous,
              ["e"] = actions.move_selection_next,
              ["U"] = function(prompt_bufnr)
                require("telescope.actions.set").shift_selection(
                  prompt_bufnr,
                  -5
                )
              end,
              ["E"] = function(prompt_bufnr)
                require("telescope.actions.set").shift_selection(
                  prompt_bufnr,
                  5
                )
              end,
              ["<C-u>"] = actions.cycle_history_prev,
              ["<C-e>"] = actions.cycle_history_next,
              ["<M-u>"] = actions.preview_scrolling_up,
              ["<M-e>"] = actions.preview_scrolling_down,
              ["s"] = actions.select_vertical,
              ["h"] = actions.select_horizontal,
              ["t"] = actions.select_tab,
              ["<C-q>"] = trouble.open,
            },
          },
          buffer_previewer_maker = function(filepath, bufnr, opts)
            require("plenary.job")
              :new({
                command = "file",
                args = { "-b", "--mime", filepath },
                on_exit = function(j)
                  if j:result()[1]:find("charset=binary", 1, true) then
                    vim.schedule(
                      function()
                        vim.api.nvim_buf_set_lines(
                          bufnr,
                          0,
                          -1,
                          false,
                          { "BINARY" }
                        )
                      end
                    )
                  else
                    require("telescope.previewers").buffer_previewer_maker(
                      filepath,
                      bufnr,
                      opts
                    )
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
}

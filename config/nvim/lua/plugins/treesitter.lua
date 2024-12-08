return {
  {
    "nvim-treesitter/nvim-treesitter",
		version = false,
    build = ":TSUpdate",
    event = { "LazyFile","VeryLazy" },
    dependencies = {
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup {
        modules = {},
        ensure_installed = {},
        sync_install = true,
        auto_install = true,
        ignore_install = {},
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            node_decremental = "<S-CR>",
            scope_incremental = false,
          },
        },
        indent = { enable = true },
        autotag = { enable = true },
        textobjects = {
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]a"] = "@parameter.outer",
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
            },
            goto_next_end = {
              ["]A"] = "@parameter.outer",
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
            },
            goto_previous_start = {
              ["[a"] = "@parameter.outer",
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
            },
            goto_previous_end = {
              ["[A"] = "@parameter.outer",
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/master/scripts/minimal_init.lua#L41
              ["af"] = "@function.outer",
              ["kf"] = "@function.inner",
              ["ab"] = "@block.outer",
              ["kb"] = "@block.inner",
              ["aa"] = "@parameter.outer",
              ["ka"] = "@parameter.inner",
              ["ac"] = "@comment.outer",
            },
            include_surrounding_whitespace = true,
          },
        },
      }
    end,
  },
}

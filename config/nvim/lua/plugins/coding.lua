return {
  {
    "kylechui/nvim-surround",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt", "vim" },
      check_ts = true,
      enable_check_bracket_line = true,
      fast_wrap = {
        chars = { "{", "(", "[", "<", '"', "'", "`" },
      },
    },
    -- TODO: remove this block when https://github.com/windwp/nvim-autopairs/pull/363 is merged
    config = function(opts)
      local autopairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      autopairs.setup(opts)
      autopairs.add_rules {
        Rule("<", ">"):with_pair(cond.before_regex "%a+"):with_move(function(o) return o.char == ">" end),
      }
    end,
    -- END TODO
  },

  -- Incremental LSP renaming based on Neovim's command-preview feature
  {
    "smjonas/inc-rename.nvim",
    keys = {
      {
        "grn",
        function() return ":IncRename " .. vim.fn.expand "<cword>" end,
        silent = true,
        expr = true,
      },
    },
    opts = {
      preview_empty_name = true,
    },
  },

  -- Sorting plugin that supports line-wise and delimiter sorting
  {
    "sQVe/sort.nvim",
    keys = {
      { "gso", ":Sort<CR>", mode = "n", silent = true },
      { "gso", "<Esc>:Sort<CR>", mode = "v", silent = true },
    },
  },
}

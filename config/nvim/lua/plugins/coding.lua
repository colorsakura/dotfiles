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
        Rule("<", ">")
          :with_pair(cond.before_regex "%a+")
          :with_move(function(o) return o.char == ">" end),
      }
    end,
    -- END TODO
  },
  -- Sorting plugin that supports line-wise and delimiter sorting
  {
    "sQVe/sort.nvim",
    keys = {
      { "gos", ":Sort<CR>", mode = "n", silent = true },
      { "gos", "<Esc>:Sort<CR>", mode = "v", silent = true },
    },
  },
}

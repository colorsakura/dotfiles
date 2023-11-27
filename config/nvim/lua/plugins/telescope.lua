return {
  "telescope.nvim",
  keys = {
    {
      ";m",
      function()
        local builtin = require("telescope.builtin")
        builtin.marks()
      end,
    },
    {
      ";s",
      function()
        local builtin = require("telescope.builtin")
        builtin.treesitter()
      end,
    },
  },
}

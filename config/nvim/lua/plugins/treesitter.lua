return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    highlight = {
      disable = function(_, bufnr)
        local buf_name = vim.api.nvim_buf_get_name(bufnr)
        local file_size = vim.api.nvim_call_function("getfsize", { buf_name })
        return file_size > 256 * 1024
      end,
    },
  },
}

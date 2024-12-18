return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      function OpenMarkdownPreview(url) vim.fn.system("firefox " .. url) end
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
    end,
    ft = { "markdown" },
  },
}

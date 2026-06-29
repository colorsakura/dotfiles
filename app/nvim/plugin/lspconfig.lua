-- vim: ts=2 tw=80

vim.pack.add({
  _G.gh("neovim/nvim-lspconfig"),
  _G.gh("nvimtools/none-ls.nvim"),
  _G.gh("nvim-lua/plenary.nvim"),
})

vim.lsp.enable(_G.config.lsp)
local ok, null_ls = pcall(require, "null-ls")
if ok then
  null_ls.setup({})
end

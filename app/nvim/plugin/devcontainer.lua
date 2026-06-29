-- vim: ts=2 tw=80

vim.pack.add({
  _G.gh("akinsho/toggleterm.nvim"),
  _G.gh("erichlf/devcontainer-cli.nvim"),
})

local ok, devcontainer = pcall(require, "devcontainer-cli")

if ok then
  devcontainer.setup({
    toplevel = true,
  })
end

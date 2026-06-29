vim.pack.add({
  _G.gh("stevearc/oil.nvim"),
})

local ok, oil = pcall(require, "oil")

if ok then
  oil.setup({
    win_options = {
      number = false,
      relativenumber = false,
    },
  })


  vim.keymap.set({ "n" }, "<leader>e", function()
    require("oil").open_float()
  end, { desc = "Open Oil" })
end

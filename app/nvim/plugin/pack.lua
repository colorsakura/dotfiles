-- vim: ts=2 tw=80

-- TODO: 添加便捷工具 更新单个插件
vim.api.nvim_create_user_command("Update", function()
  vim.pack.update()
end, { desc = "Update pack plugins" })

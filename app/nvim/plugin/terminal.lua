-- vim: ts=2 tw=80

-- TODO: 优化内置 terminal 使用体验

vim.keymap.set("n", "<space>wt", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 5)

  job_id = vim.bo.channel
end)

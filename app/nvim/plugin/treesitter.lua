-- vim: ts=2 tw=80

vim.pack.add({
  {
    src = _G.gh("nvim-treesitter/nvim-treesitter"),
    version = "main",
  },
  {
    src = _G.gh("nvim-treesitter/nvim-treesitter-textobjects"),
    version = "main",
  },
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = _G.config.treesitter,
  callback = function()
    -- 只在支持 treesitter 的文件类型启动
    pcall(vim.treesitter.start, 0)
    if pcall(function()
      return vim.treesitter.get_parser()
    end) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- TODO: 使用 treesitter 扩展文本对象

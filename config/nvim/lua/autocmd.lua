-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "grug-far",
    "help",
    "lspinfo",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "dbout",
    "gitsigns.blame",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Quit buffer",
    })
  end,
})

-- vim.api.nvim_create_autocmd("BufWinEnter", {
--   group = vim.api.nvim_create_augroup("IrreplaceableWindows", { clear = true }),
--   pattern = "*",
--   callback = function()
--     local filetypes = { "toggleterm", "neo-tree" }
--     local buftypes = { "terminal" }
--     if vim.tbl_contains(buftypes, vim.bo.buftype) and vim.tbl_contains(filetypes, vim.bo.filetype) then
--       vim.cmd "set wimfixuf"
--     end
--   end,
-- })

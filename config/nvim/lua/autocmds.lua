-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "alpha",
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

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match "^%w%w+:[\\/][\\/]" then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--   group = vim.api.nvim_create_augroup("alpha", { clear = true }),
--   callback = function()
--     local wins = vim.api.nvim_tabpage_list_wins(0)
--     if #wins <= 1 then return end
--     local ignore_ft = { ["neo-tree"] = true }
--     for _, winid in ipairs(wins) do
--       if vim.api.nvim_win_is_valid(winid) then
--         local bufnr = vim.api.nvim_win_get_buf(winid)
--         local filetype = vim.bo[bufnr].filetype
--         -- If any visible windows are not sidebars, early return
--         if not ignore_ft[filetype] then
--           return
--           -- If the visible window is a sidebar
--         else
--           -- only count filetypes once, so remove a found sidebar from the detection
--           ignore_ft[filetype] = nil
-- 					vim.cmd("Alpha")
--         end
--       end
--     end
--   end,
-- })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() (vim.hl or vim.highlight).on_yank() end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = vim.api.nvim_create_augroup("core.checktime", { clear = true }),
    callback = function()
        if vim.o.buftype ~= "nofile" then vim.cmd "checktime" end
    end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("core.close_with_q", { clear = true }),
    pattern = {
        "checkhealth",
        "dbout",
        "gitsigns-blame",
        "grug-far",
        "help",
        "lspinfo",
        "neotest-output",
        "neotest-output-panel",
        "neotest-summary",
        "notify",
        "oil",
        "PlenaryTestPopup",
        "qf",
        "spectre_panel",
        "startuptime",
        "tsplayground",
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

-- Quit Neovim if more than one window is open and only sidebar windows are list
vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("core.quit_only_sidebars", { clear = true }),
    callback = function()
        local wins = vim.api.nvim_tabpage_list_wins(0)
        -- Both neo-tree and aerial will auto-quit if there is only a single window left
        if #wins <= 1 then return end
        local sidebar_fts = { aerial = true, ["neo-tree"] = true }
        for _, winid in ipairs(wins) do
            if vim.api.nvim_win_is_valid(winid) then
                local bufnr = vim.api.nvim_win_get_buf(winid)
                local filetype = vim.bo[bufnr].filetype
                -- If any visible windows are not sidebars, early return
                if not sidebar_fts[filetype] then
                    return
                -- If the visible window is a sidebar
                else
                    -- only count filetypes once, so remove a found sidebar from the detection
                    sidebar_fts[filetype] = nil
                end
            end
        end
        if #vim.api.nvim_list_tabpages() > 1 then
            vim.cmd.tabclose()
        else
            vim.cmd.qall()
        end
    end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = vim.api.nvim_create_augroup("core.resize_splits", { clear = true }),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd "tabdo wincmd ="
        vim.cmd("tabnext " .. current_tab)
    end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("core.last_loc", { clear = true }),
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then return end
        vim.b[buf].last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
    end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("core.man_unlisted", { clear = true }),
    pattern = { "man" },
    callback = function(event) vim.bo[event.buf].buflisted = false end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("core.wrap_spell", { clear = true }),
    pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
    callback = function() vim.opt_local.wrap = true end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = vim.api.nvim_create_augroup("core.auto_create_dir", { clear = true }),
    callback = function(ev)
        if ev.match:match "^%w%w+:[\\/][\\/]" then return end
        local file = vim.uv.fs_realpath(ev.match) or ev.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- Treesitter highlight
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = vim.api.nvim_create_augroup("core.ts_highlight", { clear = true }),
    pattern = {
        "c",
        "cpp",
        "css",
        "go",
        "html",
        "java",
        "javascript",
        "jsx",
        "lua",
        "markdown",
        "python",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "yaml",
        "zig",
    },
    callback = function(ev)
        vim.schedule(function() vim.treesitter.start() end)

        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
})

return {
  {
    "ibhagwan/fzf-lua",
    cmd = { "FzfLua" },
    opts = function()
      return {
        winopts = {
          border = vim.g.border or "single",
          width = 0.8,
          height = 0.8,
          row = 0.5,
          col = 0.5,
          preview = {
            border = vim.g.border or "single",
            scrollchars = { "┃", "" },
          },
          treesitter = {
            enabled = true,
          },
        },
        ui_select = function(fzf_opts, items)
          return vim.tbl_deep_extend("force", fzf_opts, {
            prompt = " ",
            winopts = {
              title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
              title_pos = "center",
            },
          }, fzf_opts.kind == "codeaction" and {
            winopts = {
              layout = "vertical",
              -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
              height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
              width = 0.5,
              preview = not vim.tbl_isempty(Editor.lsp.get_clients { bufnr = 0, name = "vtsls" }) and {
                layout = "vertical",
                vertical = "down:15,border-top",
                hidden = "hidden",
              } or {
                layout = "vertical",
                vertical = "down:15,border-top",
              },
            },
          } or {
            winopts = {
              width = 0.5,
              -- height is number of items, with a max of 80% screen height
              height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
            },
          })
        end,
      }
    end,
    keys = {
      -- find
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Find Buffers" },
      { "<leader>f/", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },
      { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
      -- git
      { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Commits" },
      { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Status" },
      -- search
    },
    init = function()
      Editor.on_very_lazy(function()
        vim.ui.select = function(...)
          require("lazy").load { plugins = { "fzf-lua" } }
          local opts = Editor.opts("fzf-lua") or {}
          require("fzf-lua").register_ui_select(opts.ui_select or {})
          return vim.ui.select(...)
        end
      end)
    end,
    config = function(_, opts) require("fzf-lua").setup(opts) end,
  },
}

return {
  -- A pretty list to show diagnostics, references, and quickfix results
  {
    "folke/trouble.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    cmd = { "Trouble" },
    keys = {
      { ",e", ":Trouble diagnostics toggle<CR>", silent = true },
      { ",E", ":Trouble diagnostics toggle filter.buf=0<CR>", silent = true },
      { ",q", ":Trouble qflist toggle<CR>", silent = true },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous { skip_groups = true, jump = true }
          else
            vim.cmd.cprev()
          end
        end,
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next { skip_groups = true, jump = true }
          else
            vim.cmd.cnext()
          end
        end,
      },
    },
    opts = {
      action_keys = {
        previous = "u",
        next = "e",

        jump = "<Tab>",
        jump_close = "<CR>",

        open_split = "s",
        open_vsplit = "S",
        open_tab = "t",

        toggle_fold = "za",
        open_folds = "zr",
        close_folds = "zm",
      },
    },
    config = function(opts)
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "Trouble",
        callback = function(event)
          if require("trouble.config").options.mode ~= "telescope" then return end

          local function delete()
            local folds = require "trouble.folds"
            local telescope = require "trouble.providers.telescope"

            local ord = { "" } -- { filename, ... }
            local files = { [""] = { 1, 1, 0 } } -- { [filename] = { start, end, start_index } }
            for i, result in ipairs(telescope.results) do
              if files[result.filename] == nil then
                local next = files[ord[#ord]][2] + 1
                files[result.filename] = { next, next, i }
                table.insert(ord, result.filename)
              end
              if not folds.is_folded(result.filename) then files[result.filename][2] = files[result.filename][2] + 1 end
            end

            local line = unpack(vim.api.nvim_win_get_cursor(0))
            for i, id in ipairs(ord) do
              if line == files[id][1] then -- Group
                local next = ord[i + 1]
                for _ = files[id][3], next and files[next][3] - 1 or #telescope.results do
                  table.remove(telescope.results, files[id][3])
                end
                break
              elseif line <= files[id][2] then -- Item
                table.remove(telescope.results, files[id][3] + (line - files[id][1]) - 1)
                break
              end
            end

            if #telescope.results == 0 then
              require("trouble").close()
            else
              require("trouble").refresh { provider = "telescope", auto = false }
            end
          end

          vim.keymap.set("n", "x", delete, { buffer = event.buf })
        end,
      })

      require("trouble").setup(opts)
    end,
  },
}

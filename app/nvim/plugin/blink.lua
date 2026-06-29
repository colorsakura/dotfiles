vim.pack.add({
  {
    src = _G.gh("saghen/blink.cmp"),
    version = vim.version.range("1.*"),
  },
  {
    src = _G.gh("saghen/blink.lib"),
  },
  {
    src = _G.gh("saghen/blink.pairs"),
  },
  {
    src = _G.gh("saghen/blink.indent")
  }
})

local ok, cmp = pcall(require, "blink.cmp")

if ok then
  vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
    once = true,
    callback = function()
      cmp.setup({
        completion = {
          list = {
            selection = {
              preselect = function(ctx)
                return not require("blink.cmp").snippet_active({ direction = 1 })
              end,
            },
          },

          menu = {
            auto_show = true,
            draw = {
              columns = {
                { "kind_icon" },
                { "label",      "label_description", gap = 1 },
                { "source_name" }
              }
            }
          }
        },

        keymap = {
          preset = "super-tab",
        },
        cmdline = {
          keymap = { preset = "inherit" },
          completion = { menu = { auto_show = true } },
        },
        sources = {
          -- add lazydev to your completion providers
          default = { "lazydev", "lsp", "path", "snippets", "buffer" },
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              -- make lazydev completions top priority (see `:h blink.cmp`)
              score_offset = 100,
            },
          },
        },
      })
    end,
  })
end

local Ok, pairs = pcall(require, "blink.pairs")

if Ok then
  vim.schedule(function()
    pairs.build():pwait(60000)
  end
  )
  pairs.setup({})
  require("blink.indent").setup({})
end
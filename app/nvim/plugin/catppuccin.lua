-- vim: ts=2 tw=80

vim.pack.add({
  {
    src = _G.gh("catppuccin/nvim"),
    name = "catppuccin",
    version = "main",
  },
})

local ok, catppuccin = pcall(require, "catppuccin")

if ok then
  catppuccin.setup({
    default_integrations = false,
    transparent_background = true,
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
      comments = { "italic" }, -- Change the style of comments
      conditionals = { "italic" },
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
      -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    integrations = {
      blink_cmp = true,
      blink_pairs = true,
      snacks = { enabled = true },
      leap = true,
      which_key = true,
      fzf = true,
      mini = {
        enabled = true,
      },
      treesitter_context = true,
    },
  })
  vim.cmd("colorscheme catppuccin")
end

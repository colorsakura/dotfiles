return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "onsails/lspkind.nvim",
    },
    opts = {
      formatting = {
        fields = { "kind", "abbr" },
        format = function(_, vim_item)
          local lspkind = require("lspkind").presets.default
          local icons = require("lazyvim.config").icons.kinds
          if lspkind[vim_item.kind] then
            vim_item.kind = string.format("%s", lspkind[vim_item.kind])
          else
            vim_item.kind = string.format("%s", icons[vim_item.kind])
          end
          return vim_item
        end,
      },
    },
  },
}

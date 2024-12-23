return {
  {
    "b0o/schemastore.nvim",
    lazy = true,
    ft = { "json", "jsonc" },
    config = function(_, opts)
      require("lspconfig").jsonls.setup {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      }
    end,
  },
}

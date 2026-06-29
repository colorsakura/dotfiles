---@diagnostic disable: missing-fields, inject-field

---@type vim.lsp.ClientConfig
return {
  settings = {
    json = {
      validate = {
        enable = true,
      },
    },
  },
  before_init = function(_, config)
    -- can't assign new table because of
    -- https://github.com/neovim/neovim/issues/27740#issuecomment-1978629315
    config.settings.json.schemas = require("schemastore").json.schemas()
  end,
}

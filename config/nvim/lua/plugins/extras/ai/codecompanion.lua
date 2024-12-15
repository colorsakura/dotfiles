return {
  {
    "olimorris/codecompanion.nvim",
    lazy = true,
    cmd = { "CodeCompanionChat" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup {
        strategies = {
          chat = {
            adapter = "gemini",
          },
          inline = {
            adapter = "gemini",
            keymaps = {
              accept_change = {
                modes = {
                  n = "<C-Enter>",
                },
                index = 1,
                callback = "keymaps.accept_change",
                description = "Accept change",
              },
            },
          },
        },
        adapters = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = { api_key = "GOOGLE_AI_API_KEY" },
              model = "gemini-2.0-flash-exp",
            })
          end,
        },
      }
    end,
  },
}

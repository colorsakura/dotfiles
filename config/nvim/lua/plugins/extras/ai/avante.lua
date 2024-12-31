-- ISSUE: 即使设置`auto_set_keymaps = false`, Avante 还是会自动绑定按键

return {
  {
    "yetone/avante.nvim",
    lazy = true,
    cmd = { "AvanteChat" },
    version = false,
    keys = {
      { "<leader>ac", function() require("avante").toggle() end, desc = "AI Chat" },
    },
    opts = {
      provider = "gemini",
      gemini = {
        api_key_name = "GOOGLE_AI_API_KEY",
        model = "gemini-2.0-flash-exp",
      },
      -- moonshot
      vendors = {
        moonshot = {
          __inherited_from = "openai",
          endpoint = "https://api.moonshot.cn/v1",
          api_key_name = "MOONSHOT_AI_API_KEY",
          model = "moonshot-v1-8k",
        },
      },
      behaviour = {
        auto_suggestions = false, -- 由其他免费的工具提供: codeium, supermaven
        auto_set_keymaps = false,
      },
      hints = { enabled = false }, -- TODO: 不知道有什么用
      windows = {
        input = {
          height = 3,
        },
        sidebar_header = {
          enabled = true,
          rounded = false,
        },
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = function()
      if Editor.is_win() then
        return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
      end
      return "make"
    end,
    dependencies = {
      -- "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        optional = true,
        lazy = true,
        opts = {
          file_types = { "Avante" },
        },
        ft = { "Avante" },
      },
    },
    config = function(_, opts)
      require("avante_lib").load()
      require("avante").setup(opts)
    end,
  },
}

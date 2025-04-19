-- ISSUE: 即使设置`auto_set_keymaps = false`, Avante 还是会自动绑定按键

return {
    {
        "yetone/avante.nvim",
        lazy = true,
        cmd = { "AvanteChat" },
        version = false,
        ---@class avante.Config
        opts = {
            provider = "moonshot",
            gemini = {
                api_key_name = "GOOGLE_AI_API_KEY",
                model = "gemini-2.5-pro-exp-03-25",
            },
            copilot = {
                model = "claude-3.5-sonnet",
            },
            -- moonshot
            vendors = {
                moonshot = {
                    __inherited_from = "openai",
                    endpoint = "https://api.moonshot.cn/v1",
                    api_key_name = "MOONSHOT_API_KEY",
                    model = "moonshot-v1-8k",
                    disable_tools = true,
                },
                deepseek = {
                    __inherited_from = "openai",
                    endpoint = "https://api.deepseek.com",
                    api_key_name = "DEEPSEEK_API_KEY",
                    model = "deepseek-chat",
                },
            },
            behaviour = {
                auto_suggestions = false, -- 由其他免费的工具提供: codeium, supermaven
                auto_set_keymaps = true,
                -- enable_token_counting = false,
            },
            mappings = {
                ask = "<leader>aa",
                edit = "<leader>ae",
                refresh = "<leader>ar",
                focus = "<leader>af",
                toggle = {
                    default = "<leader>at",
                    debug = "<leader>ad",
                    hint = "<leader>ah",
                    suggestion = "<leader>as",
                    repomap = "<leader>aR",
                },
                files = {
                    add_current = "<leader>ac", -- Add current buffer to selected files
                },
            },
            hints = { enabled = false }, -- TODO: 不知道有什么用
            windows = {
                input = {
                    -- height = 5,
                },
                sidebar_header = {
                    enabled = false,
                },
            },
        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false", -- for windows
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "MeanderingProgrammer/render-markdown.nvim",
        },
    },
}

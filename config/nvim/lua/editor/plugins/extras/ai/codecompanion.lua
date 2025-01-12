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
                display = {
                    chat = {
                        window = {
                            opts = {
                                number = false,
                            },
                        },
                    },
                },
                strategies = {
                    chat = {
                        adapter = "gemini",
                        roles = {
                            llm = "Assistant",
                            user = "You",
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

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
                opts = {
                    language = "Chinese",
                },
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
                        adapter = "moonshot",
                        roles = {
                            llm = "Assistant",
                            user = "You",
                        },
                    },
                },
                adapters = {
                    gemini = function()
                        return require("codecompanion.adapters").extend("gemini", {
                            env = { api_key = "GOOGLE_API_KEY" },
                            model = "gemini-2.0-flash",
                        })
                    end,
                    moonshot = function()
                        return require("codecompanion.adapters").extend("openai_compatible", {
                            env = {
                                url = "https://api.moonshot.cn/v1",
                                api_key = "MOONSHOT_API_KEY",
                            },
                            schema = {
                                default = {
                                    model = "moonshot-v1-8k",
                                },
                            },
                        })
                    end,
                },
            }
        end,
    },
}

local M = {}

local defaults = {
    ---@type string|fun()
    -- colorscheme = function() require("catppuccin").load() end,
    colorscheme = "arctic",
    colors = {
        text = "",
        subtext1 = "",
        subtext0 = "",
        overlay2 = "",
        overlay1 = "",
        overlay0 = "",
        surface2 = "",
        surface1 = "",
        surface0 = "",
        base = "#151b23",
        mantle = "",
        crust = "",
        blue = "",
        cyan = "",
        green = "",
        magenta = "",
        orange = "",
        pink = "",
        purple = "",
        red = "",
        white = "",
        yellow = "",
    },
    -- icons used by other plugins
    icons = {
        ft = {
            octo = " ",
        },
        dap = {
            Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
            Breakpoint = " ",
            BreakpointCondition = " ",
            BreakpointRejected = { " ", "DiagnosticError" },
            LogPoint = ".>",
        },
        diagnostics = {
            Error = " ",
            Warn = " ",
            Hint = " ",
            Info = " ",
        },
        git = {
            added = " ",
            branch = " ",
            commit = "",
            deleted = " ",
            diff = " ",
            git = "󰊢 ",
            modified = " ",
        },
        kinds = {
            Array = " ",
            Boolean = "󰨙 ",
            Class = " ",
            Codeium = "󰘦 ",
            Color = " ",
            ColorSwatch = "██",
            Control = " ",
            Collapsed = " ",
            Constant = " ",
            Constructor = " ",
            Enum = " ",
            EnumMember = " ",
            Event = " ",
            Field = " ",
            File = " ",
            Folder = " ",
            Function = " ",
            Interface = " ",
            Key = " ",
            Keyword = " ",
            Method = " ",
            Module = " ",
            Namespace = "󰦮 ",
            Null = " ",
            Number = "󰎠 ",
            Object = " ",
            Operator = " ",
            Package = " ",
            Property = " ",
            Reference = " ",
            Snippet = " ",
            String = " ",
            Struct = " ",
            Text = " ",
            TypeParameter = " ",
            Unit = " ",
            Value = " ",
            Variable = " ",
        },
        separators = {
            bar = "│",
            bar_left_bold = "▎",
            bar_right_bold = "🮇",
            chevron_left = "",
            chevron_right = "",
            triangle_left = "",
            triangle_right = "",
        },
        caret = {
            down = "",
            left = "",
            right = "",
        },
        access = {
            public = "○",
            protected = "◉",
            private = "●",
        },
        misc = {
            book = " ",
            dots = "󰇘 ",
            Supermaven = " ",
            TabNine = "󰏚 ",
            check = " ",
            Copilot = " ",
            circle_filled = "",
            color = " ",
            command = " ",
            disconnect = " ",
            edit = " ",
            ellipsis = " ",
            explorer = " ",
            file = " ",
            file_code = " ",
            folder = "󰉋 ",
            format = " ",
            graph = " ",
            help = " ",
            lightbulb = "",
            lightning_bolt = "󱐋",
            list = " ",
            location = "",
            indent = " ",
            logo = "󰀘 ",
            maximized = " ",
            mode = "▊",
            neovim = " ",
            note = " ",
            outline = " ",
            page_previous = "󰮳 ",
            quickfix = " ",
            rocket = " ",
            search = " ",
            source_control = " ",
            switch_on = " ",
            switch_off = " ",
            task = " ",
            term = " ",
            tree = " ",
        },
    },
    ---@type table<string, string[]|boolean>?
    kind_filter = {
        default = {
            "Class",
            "Constructor",
            "Enum",
            "Field",
            "Function",
            "Interface",
            "Method",
            "Module",
            "Namespace",
            "Package",
            "Property",
            "Struct",
            "Trait",
        },
        markdown = false,
        help = false,
        -- you can specify a different filter for each filetype
        lua = {
            "Class",
            "Constructor",
            "Enum",
            "Field",
            "Function",
            "Interface",
            "Method",
            "Module",
            "Namespace",
            -- "Package", -- remove package since luals uses it for control flow structures
            "Property",
            "Struct",
            "Trait",
        },
        zig = {
            "Class",
            "Constructor",
            "Constant",
            "Enum",
            "Field",
            "Function",
            "Interface",
            "Method",
            "Module",
            "Namespace",
            "Package",
            "Property",
            "Struct",
            "Trait",
        },
    },
}

local options

function M.setup(opts)
    options = vim.tbl_deep_extend("force", defaults, opts or {}) or {}

    M.load "options"
    M.load "keymaps"
    M.load "autocmds"

    if type(M.colorscheme) == "function" then
        M.colorscheme()
    else
        vim.cmd.colorscheme(M.colorscheme)
    end
end

function M.load(name) require("core.config." .. name) end

setmetatable(M, {
    __index = function(_, key)
        if options == nil then return vim.deepcopy(defaults)[key] end
        return options[key]
    end,
})

return M

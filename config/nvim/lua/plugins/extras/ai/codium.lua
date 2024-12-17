return {
  -- codeium
  {
    "Exafunction/codeium.nvim",
    cmd = "Codeium",
    build = ":Codeium Auth",
    event = "LazyFile",
    opts = {
      enable_cmp_source = false,
      virtual_text = {
        enabled = true,
        key_bindings = {
          accept = "<C-Enter>",
          clear = "<C-l>",
          next = "<A-]>",
          prev = "<A-[>",
        },
      },
    },
    config = function(_, opts) require("codeium").setup(opts) end,
  },
}

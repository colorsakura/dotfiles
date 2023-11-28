return {
  "epwalsh/obsidian.nvim",
  lazy = true,
  ft = "markdown",
  opts = {
    workspaces = {
      {
        name = "Personal",
        path = "~/Documents/Obsidian/",
      },
    },
    disable_frontmatter = true,
  },
}

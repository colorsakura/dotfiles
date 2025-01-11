# Neovim

A beautiful and powerful tui editor.

## 运行时文件

Neovim 会自动加载位于`runtimepath` 中的一些特殊目录的 lua 文件。

- colors/
- compiler/
- ftplugin/
- indent/
- plugin/
- syntax/

> [!note] 同一个运行时目录中，vim 文件会优先于所有 lua 文件。

## Plugins

### core

Neovim 的核心配置，不需要外部插件依赖。

| Name            | Desc                  | Status                                               |
| --------------- | --------------------- | ---------------------------------------------------- |
| lazy.nvim       | plugins manager       | <https://github.com/folke/lazy.nvim>                 |
| nvim-treesitter | syntax highlighting   | <https://github.com/nvim-treesitter/nvim-treesitter> |
| nvim-lspconfig  | lsp config for neovim | <https://github.com/neovim/nvim-lspconfig>           |
| neo-tree        | file explorer         | <https://github.com/nvim-neo-tree/neo-tree.nvim>     |

### motion


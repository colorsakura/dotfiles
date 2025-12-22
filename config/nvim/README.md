# Neovim 配置

一个美观且功能强大的终端编辑器配置。

## 特性

- **现代化 UI**: 使用 Catppuccin 主题，提供美观的界面
- **智能补全**: Blink.cmp 提供快速准确的代码补全
- **语法高亮**: 通过 Treesitter 提供增强的语法高亮
- **LSP 支持**: 集成多种语言服务器，提供代码分析和智能提示
- **文件管理**: Neo-tree 文件浏览器，方便的文件操作
- **搜索替换**: FzfLua 提供快速文件和内容搜索
- **代码格式化**: Conform.nvim 集成多种格式化工具
- **Git 集成**: Gitsigns 显示 Git 变更，Diffview 提供差异对比
- **终端集成**: ToggleTerm 提供便捷的终端访问

## 插件列表

### 核心插件

| 插件 | 描述 | 仓库 |
|------|------|------|
| lazy.nvim | 插件管理器 | <https://github.com/folke/lazy.nvim> |
| catppuccin | 主题 | <https://github.com/catppuccin/nvim> |
| blink.cmp | 代码补全 | <https://github.com/saghen/blink.cmp> |
| nvim-lspconfig | LSP 配置 | <https://github.com/neovim/nvim-lspconfig> |
| conform.nvim | 代码格式化 | <https://github.com/stevearc/conform.nvim> |

### 编辑插件

| 插件 | 描述 | 仓库 |
|------|------|------|
| neo-tree.nvim | 文件浏览器 | <https://github.com/nvim-neo-tree/neo-tree.nvim> |
| flash.nvim | 快速跳转 | <https://github.com/folke/flash.nvim> |
| which-key.nvim | 键位提示 | <https://github.com/folke/which-key.nvim> |
| gitsigns.nvim | Git 集成 | <https://github.com/lewis6991/gitsigns.nvim> |
| mini.surround | 围绕操作 | <https://github.com/echasnovski/mini.nvim> |

### UI 插件

| 插件 | 描述 | 仓库 |
|------|------|------|
| snacks.nvim | 实用工具集合 | <https://github.com/folke/snacks.nvim> |
| aerial.nvim | 代码大纲 | <https://github.com/stevearc/aerial.nvim> |
| bufferline.nvim | 标签页管理 | <https://github.com/akinsho/bufferline.nvim> |
| fzf-lua | 模糊搜索 | <https://github.com/ibhagwan/fzf-lua> |
| trouble.nvim | 诊断列表 | <https://github.com/folke/trouble.nvim> |

### 其他插件

| 插件 | 描述 | 仓库 |
|------|------|------|
| nvim-treesitter | 语法高亮 | <https://github.com/nvim-treesitter/nvim-treesitter> |
| todo-comments.nvim | 待办事项高亮 | <https://github.com/folke/todo-comments.nvim> |
| toggleterm.nvim | 终端集成 | <https://github.com/akinsho/toggleterm.nvim> |
| lazydev.nvim | Lua 开发环境 | <https://github.com/folke/lazydev.nvim> |
| noice.nvim | UI 增强 | <https://github.com/folke/noice.nvim> |

## 安装

1. 备份当前 Neovim 配置（如果存在）：
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. 克隆配置仓库：
   ```bash
   git clone https://github.com/iFlygo/dotfiles ~/.dotfiles
   ```

3. 创建符号链接：
   ```bash
   ln -s ~/.dotfiles/config/nvim ~/.config/nvim
   ```

4. 启动 Neovim 并等待插件自动安装：
   ```bash
   nvim
   ```

5. 首次启动后，运行以下命令确保所有插件正确安装：
   ```vim
   :Lazy sync
   ```

## 使用

- `<leader>` 键映射为 `Space`
- `<A-m>` 或 `<leader>e` 打开文件浏览器
- `<leader>ff` 搜索文件
- `<leader>f/` 搜索内容
- `<leader>ca` 打开代码大纲
- `<C-`>` 打开终端

## 贡献

欢迎提交 Issue 和 Pull Request 来改进此配置。

## 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](../LICENSE) 文件。







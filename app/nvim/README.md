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
- **自动括号匹配**: 自动插入和删除括号、引号等配对字符
- **代码片段支持**: 支持多种代码片段引擎，提高编码效率
- **多光标编辑**: 支持多光标操作，批量编辑更高效
- **窗口管理**: 窗口分割、调整大小和导航功能

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
| nvim-autopairs | 自动括号匹配 | <https://github.com/windwp/nvim-autopairs> |
| nvim-ts-context-commentstring | 智能注释 | <https://github.com/JoosepAlviste/nvim-ts-context-commentstring> |
| comment.nvim | 注释插件 | <https://github.com/numtostr/comment.nvim> |
| illuminate.nvim | 变量高亮 | <https://github.com/RRethy/vim-illuminate> |

### UI 插件

| 插件 | 描述 | 仓库 |
|------|------|------|
| snacks.nvim | 实用工具集合 | <https://github.com/folke/snacks.nvim> |
| aerial.nvim | 代码大纲 | <https://github.com/stevearc/aerial.nvim> |
| bufferline.nvim | 标签页管理 | <https://github.com/akinsho/bufferline.nvim> |
| fzf-lua | 模糊搜索 | <https://github.com/ibhagwan/fzf-lua> |
| trouble.nvim | 诊断列表 | <https://github.com/folke/trouble.nvim> |
| lualine.nvim | 状态栏 | <https://github.com/nvim-lualine/lualine.nvim> |
| indent-blankline.nvim | 缩进线 | <https://github.com/lukas-reineke/indent-blankline.nvim> |

### 其他插件

| 插件 | 描述 | 仓库 |
|------|------|------|
| nvim-treesitter | 语法高亮 | <https://github.com/nvim-treesitter/nvim-treesitter> |
| todo-comments.nvim | 待办事项高亮 | <https://github.com/folke/todo-comments.nvim> |
| toggleterm.nvim | 终端集成 | <https://github.com/akinsho/toggleterm.nvim> |
| lazydev.nvim | Lua 开发环境 | <https://github.com/folke/lazydev.nvim> |
| noice.nvim | UI 增强 | <https://github.com/folke/noice.nvim> |
| mason.nvim | LSP/格式化工具管理 | <https://github.com/williamboman/mason.nvim> |
| mason-lspconfig.nvim | Mason-LSP 配置桥接 | <https://github.com/williamboman/mason-lspconfig.nvim> |

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

### 基础键位映射

- `<leader>` 键映射为 `Space`
- `<A-m>` 或 `<leader>e` 打开文件浏览器
- `<leader>ff` 搜索文件
- `<leader>f/` 搜索内容
- `<leader>ca` 打开代码大纲
- `<C-`>` 打开终端

### 文件操作

- `<leader>e` 或 `<A-m>` - 打开/关闭文件浏览器
- `<leader>fn` - 新建文件
- `<leader>fr` - 重命名文件
- `<leader>fd` - 删除文件

### 搜索与导航

- `<leader>ff` - 搜索文件
- `<leader>f/` - 在文件中搜索内容
- `<leader>fg` - 搜索 Git 仓库中的内容
- `<leader>fb` - 切换缓冲区
- `<leader><space>` - 最近打开的文件

### 代码操作

- `<leader>ca` - 代码操作（重构、实现等）
- `<leader>cr` - 重命名变量/函数
- `<leader>cf` - 格式化代码
- `<leader>cd` - 查看定义
- `<leader>ci` - 查看实现
- `<leader>ct` - 查看类型定义

### Git 操作

- `<leader>gg` - 打开 Git GUI
- `<leader>gc` - 提交更改
- `<leader>gb` - 查看分支
- `<leader>gd` - 查看差异

### 窗口与标签页

- `<leader>w` - 窗口操作菜单
- `<leader>wh` - 向左移动窗口
- `<leader>wl` - 向右移动窗口
- `<leader>wk` - 向上移动窗口
- `<leader>wj` - 向下移动窗口
- `<leader>wn` - 新建窗口
- `<leader>wt` - 新建标签页
- `<leader>1-9` - 切换到对应编号的标签页

### 终端

- `<C-`>` - 打开/关闭浮动终端
- `<leader>t` - 终端操作菜单
- `<leader>th` - 水平分割终端
- `<leader>tv` - 垂直分割终端

## 配置

### 主题设置

默认使用 Catppuccin Mocha 主题。如需更改，请编辑 `init.lua` 中的主题配置部分。

### LSP 设置

支持多种编程语言的 LSP 服务，包括但不限于：

- JavaScript/TypeScript (tsserver)
- Python (pyright)
- Lua (lua_ls)
- Rust (rust_analyzer)
- Go (gopls)
- Java (jdtls)
- C/C++ (clangd)
- 等等

LSP 服务器会自动安装，也可以通过 `:Mason` 命令手动管理。

### 格式化设置

代码格式化由 Conform.nvim 管理，支持多种格式化工具：

- Prettier (JS/TS/CSS/JSON)
- Black (Python)
- Stylua (Lua)
- Rustfmt (Rust)
- 等等

格式化会在保存时自动执行，也可以通过 `<leader>cf` 手动触发。

## 故障排除

### 插件安装缓慢

如果插件安装缓慢，可以尝试：

1. 更换 Git 代理或镜像源
2. 检查网络连接
3. 清除插件缓存：`:Lazy clean`

### LSP 无法正常工作

1. 检查是否已安装相关语言的 LSP 服务器：`:Mason`
2. 确认文件类型是否被正确识别：`:set filetype?`
3. 重启 LSP 服务器：`:LspRestart`

### 性能问题

1. 运行 `:checkhealth` 检查系统健康状况
2. 禁用不必要的插件
3. 调整 Treesitter 相关设置

## 贡献

欢迎提交 Issue 和 Pull Request 来改进此配置。

## 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](../LICENSE) 文件。







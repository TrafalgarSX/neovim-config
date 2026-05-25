# lazy.nvim → vim.pack + nvim-cmp → blink.cmp 迁移总结

## 概述

将 Neovim 配置从 lazy.nvim 迁移到 Neovim 0.12 内置的 vim.pack 插件管理系统，同时将代码补全引擎从 nvim-cmp 切换为 blink.cmp。

## 一、lazy.nvim → vim.pack

### 核心变更

- **`lua/plugins.lua`** — 删除。lazy.nvim 的启动引导代码和插件列表被替换为 `init.lua` 中的 `vim.pack.add()` 调用。
- **`lua/plugins-vscode.lua`** — 删除。VSCode-Neovim 分支的 lazy.nvim 配置迁移到 `init.lua` 中。
- **`lua/config/mason-null-ls.lua`** — 删除。未被引用，属于遗留文件。

### 新架构

```
nvim/
├── init.lua                          # 入口：vim.pack.add() + 核心配置
├── lua/
│   ├── options.lua                   # 编辑器选项
│   ├── keymaps.lua                   # 通用键位映射
│   ├── colorscheme.lua               # 配色方案（含 gruvbox-material 前期配置）
│   ├── lsp_utils.lua                 # LSP 能力（适配 blink.cmp）
│   ├── lspconfigs.lua                # LSP 服务器配置
│   ├── lsp.lua                       # Mason + LSP 启动 + 诊断符号
│   └── config/                       # 各插件配置模块（保持原有结构）
│       ├── bufferline.lua
│       ├── cmake.lua
│       ├── conform.lua
│       ├── copilot.lua
│       ├── dap.lua / dappy.lua
│       ├── flash.lua                 # 新增：键位映射
│       ├── gitsigns.lua
│       ├── lualine.lua
│       ├── nvim-autopairs.lua
│       ├── nvim-tree.lua
│       ├── nvim-treesitter.lua
│       ├── nvim-treesitter-textobjects.lua
│       ├── obsidian.lua
│       ├── persisted.lua
│       ├── snacks.lua
│       ├── snacks/                   # snacks.nvim 子模块
│       ├── telescope.lua
│       ├── toggleterm.lua
│       └── trouble.lua               # 新增：键位映射
└── after/
    └── plugin/                       # 自动加载的插件配置（按字母顺序）
        ├── aerial.lua                # require("aerial").setup({})
        ├── avante.lua                # avante.nvim 配置（不含 nvim-cmp 依赖）
        ├── blink-cmp.lua             # blink.cmp 配置（替换 nvim-cmp）
        ├── bufferline.lua
        ├── cmake.lua
        ├── comment.lua               # require("Comment").setup()
        ├── conform.lua
        ├── copilot.lua
        ├── dap.lua / dappy.lua
        ├── flash.lua
        ├── gitsigns.lua
        ├── im-select.lua             # require("im_select").setup({})
        ├── img-clip.lua              # require("img-clip").setup({...})
        ├── lualine.lua
        ├── nvim-autopairs.lua
        ├── nvim-tree.lua
        ├── nvim-treesitter.lua
        ├── nvim-treesitter-textobjects.lua
        ├── obsidian.lua
        ├── persisted.lua
        ├── snacks.lua                # require("snacks").setup(opts)
        ├── telescope.lua
        ├── toggleterm.lua
        ├── trouble.lua
        └── yazi.lua                  # require("yazi").setup({...})
```

### init.lua 结构

1. `require("options")` — 编辑器选项
2. `require("keymaps")` — 通用键位映射
3. VSCode 分支：`vim.pack.add()` 加载 VSCode 所需插件并配置
4. `PackChanged` autocmd — 处理插件安装/更新钩子：
   - nvim-treesitter 更新 → 自动 `:TSUpdate`
   - avante.nvim 安装 → 自动执行构建
   - blink.cmp 安装/更新 → 自动构建 Rust fuzzy matcher
   - telescope-fzf-native 安装/更新 → 自动 cmake/make 构建
5. `vim.pack.add({...})` — 一次性安装并加载所有插件
6. 核心配置加载：`lsp_utils` → `lspconfigs` → `lsp` → `colorscheme`
7. 诊断符号配置（`vim.diagnostic.config`）
8. `after/plugin/` 脚本由 Neovim 在启动时自动执行

### vim.pack 插件管理要点

- 所有插件由 `vim.pack.add()` 管理，放入 `core` 包（`opt/` 目录）
- 首次运行时会弹出确认对话框，列出待安装的插件
- 生成 `nvim-pack-lock.json` 锁文件，记录插件确切版本
- 更新插件使用 `:lua vim.pack.update()`
- 查看状态使用 `:checkhealth vim.pack`

## 二、nvim-cmp → blink.cmp

### 删除的插件

| 旧插件 | 说明 |
|--------|------|
| `hrsh7th/nvim-cmp` | 补全引擎，由 blink.cmp 替换 |
| `hrsh7th/cmp-nvim-lsp` | LSP 补全源，blink.cmp 内置 |
| `hrsh7th/cmp-buffer` | 缓冲区补全源，blink.cmp 内置 |
| `hrsh7th/cmp-path` | 路径补全源，blink.cmp 内置 |
| `hrsh7th/cmp-cmdline` | 命令行补全源，blink.cmp 内置 |
| `lspkind.nvim` | 补全图标，blink.cmp 内置 |

### 新增的插件

| 新插件 | 说明 |
|--------|------|
| `saghen/blink.cmp` | 补全引擎 |
| `saghen/blink.lib` | blink.cmp 依赖库 |
| `rafamadriz/friendly-snippets` | 代码片段（与 blink.cmp 内置 snippet 源配合） |
| `Kaiser-Yang/blink-cmp-avante` | avante.nvim 的 blink.cmp 补全源 |

### 配置变更

- **`lua/config/nvim-cmp.lua`** — 删除
- **`after/plugin/blink-cmp.lua`** — 新建
  - 使用 `super-tab` 键位预设（Tab 确认，类似 VSCode）
  - 补全菜单采用 nvim-cmp 风格的双列布局
  - 启用实验性签名帮助
  - 命令行补全保持类似行为（`/` / `?` 使用 buffer，`:` 使用 cmdline/path/buffer）
  - 添加 avante 补全源

- **`lua/lsp_utils.lua`** — 更新，优先使用 `blink.cmp.get_lsp_capabilities()`，fallback 到默认能力

### blink.cmp 与 copilot

当前 copilot.lua 配置中 Tab 键用于接受 copilot 建议：
```lua
keymap = {
  accept = '<Tab>',
}
```

blink.cmp 的 `super-tab` 预设也使用 Tab 键接受补全。两者同时使用时，blink.cmp 的 Tab 映射优先（因为它有 `fallback`），copilot 的 Tab 接受在 blink 不可见时生效。一般情况下可以正常工作。如有冲突，可能需要调整其中之一。

## 三、avante.nvim 适配

- 移除了 `hrsh7th/nvim-cmp` 依赖
- 添加了 `Kaiser-Yang/blink-cmp-avante` 作为补全源
- 构建钩子从 lazy.nvim 的 `build` 属性迁移到 `PackChanged` autocmd
- 其余配置保持不变

## 四、其他调整

### options.lua
- 新增 `vim.g.no_plugin_maps = true`（原在 lazy.nvim 的 nvim-treesitter-textobjects init 中）

### colorscheme.lua
- 新增 gruvbox-material 的全局变量设置（原在 lazy.nvim 的 config 函数中）

### config/flash.lua
- 新增 flash.nvim 的键位映射（原在 lazy.nvim 的 `keys` spec 中）

### config/trouble.lua
- 新增 trouble.nvim 的键位映射（原在 lazy.nvim 的 `keys` spec 中）

## 五、使用说明

### 首次使用

1. 启动 Neovim，`vim.pack.add()` 会检测到缺少的插件并弹出确认对话框
2. 按 `y` 确认安装单个插件，或按 `a` 一次性确认所有插件
3. blink.cmp 的 Rust fuzzy matcher 会自动构建（可能需要 Rust 工具链）
4. 等待所有插件安装完成后即可正常使用

### 更新插件

```vim
:lua vim.pack.update()
```

### 管理插件

- 查看状态：`:checkhealth vim.pack`
- 锁文件：`nvim-pack-lock.json`（建议纳入版本控制）
- 添加新插件：在 `init.lua` 的 `vim.pack.add({...})` 中添加
- 删除插件：从 `vim.pack.add({...})` 中移除，然后运行 `:lua vim.pack.clean()`

## 六、已删除的文件

- `lua/plugins.lua`
- `lua/plugins-vscode.lua`
- `lua/config/nvim-cmp.lua`
- `lua/config/mason-null-ls.lua`

## 七、迁移后清理

迁移完成后，旧的 lazy.nvim 插件仍然残留在磁盘上，需要手动删除以释放空间。

### 删除旧插件目录

lazy.nvim 的插件存放在 Neovim 的 data 目录下：

- **Windows**: `~/AppData/Local/nvim-data/lazy/`
- **Linux/macOS**: `~/.local/share/nvim/lazy/`

直接删除整个 `lazy/` 目录即可：

```bash
# Windows (Git Bash / PowerShell)
rm -rf ~/AppData/Local/nvim-data/lazy/

# Linux / macOS
rm -rf ~/.local/share/nvim/lazy/
```

### 删除 lazy-lock.json（如果存在）

```bash
# Windows
rm ~/AppData/Local/nvim/lazy-lock.json

# Linux / macOS
rm ~/.config/nvim/lazy-lock.json
```

### 验证

删除后，下次启动 Neovim 时 `vim.pack.add()` 会自动检测到缺失的插件，所有插件将重新安装到新的 `nvim-data/pack/core/opt/` 目录下。

> **注意**：vim.pack 管理的插件存放在 `stdpath("data")/pack/core/opt/` 下，与 lazy.nvim 的路径完全不同，两者不会冲突。但如果不再使用 lazy.nvim，删除旧目录可以节省磁盘空间。

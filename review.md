# Neovim 配置审查报告

## 概述

整体结构清晰，从 `lazy.nvim` 到 `vim.pack` 的迁移做得很好。以下是发现的问题，按严重程度排序。

---

## 🔴 严重问题

### 1. `.gitignore` 规则太宽泛 — 排除了关键锁文件

**文件**: `.gitignore`

```gitignore
*.json
node_modules/
```

`*.json` 会排除所有 JSON 文件，包括：

- **`nvim-pack-lock.json`** — 插件锁文件，MIGRATION.md 明确建议纳入版本控制
- **`.luarc.json`** — LSP 配置

**建议**：改为仅排除不需要的 JSON 文件，或使用否定规则保留锁文件：

```gitignore
lazy-lock.json
node_modules/
```

如果 `nvim-pack-lock.json` 不再存在（已迁移），也应确保 `.luarc.json` 被跟踪。

---

### 2. `dap.lua` 逻辑错误导致潜在崩溃

**文件**: `lua/config/dap.lua`，第 3 行

```lua
if not is_ok and is_ok_ui then
    return
end
```

当前逻辑：只有 `dap` **和** `dapui` 都加载失败才 return。如果 `dap` 加载成功（`is_ok = true`）但 `dapui` 加载失败（`is_ok_ui = false`），不会 return，之后第 7 行 `dapui.setup({})` 会因 `dapui` 为 `nil` 而崩溃。

**建议**：改为 `or`：

```lua
if not is_ok or not is_ok_ui then
    return
end
```

---

### 3. `dapui.setup()` 被调用了三次

**文件**: `lua/config/dap.lua`，第 7、90、232 行

`dapui.setup()` 在同一个文件中被调用了三次：

1. 第 7 行：空配置 `dapui.setup({})`
2. 第 90 行：第一次完整配置
3. 第 232 行：第二次完整配置（覆盖第一次）

只有最后一次调用生效（232 行），前两次是无效开销。第二次调用（90 行）的配置（包括 `controls`、`layouts` with `size = 0.25` 等）被第三次（232 行）的 `size = 10` 等配置覆盖。

**建议**：删除前两处 `dapui.setup()`，只保留一处完整配置。

---

### 4. 每次启动都调用 `blink.build():wait(60000)`

**文件**: `init.lua`，第 155-158 行

```lua
local blink_ok, blink = pcall(require, "blink.cmp")
if blink_ok and type(blink) == "table" and type(blink.build) == "function" then
    blink.build():wait(60000)
end
```

`PackChanged` 钩子（第 42-47 行）已经在插件安装/更新时处理 blink 构建。这里的代码会让每次启动都触发构建检查，即使已经构建好。虽然 `blink.build()` 可能是幂等的，但仍有文件校验开销和 60 秒超时。

**建议**：移除这段代码，完全依赖 `PackChanged` 钩子处理 post-install 构建。或者在第一次构建后写入标记文件避免重复。

---

## 🟡 中等问题

### 5. `options.lua` 格式损坏 — `pumheight` 挤在同一行

**文件**: `lua/options.lua`，第 13 行

```lua
smartcase = true, -- but make it case sensitive if an uppercase is entered	pumheight = 10, -- pop up menu height
```

`pumheight` 没有独立成行，注释错位。此外，`pumheight` 是 nvim-cmp 时代遗留的选项，blink.cmp 不读取 `pumheight`，该选项在 blink.cmp 下无效。

**建议**：删除 `pumheight = 10`（blink.cmp 不适用），或至少让它独立成行。

---

### 6. `vim.treesitter.start()` 已过时

**文件**: `lua/config/nvim-treesitter.lua`，第 16 行

```lua
vim.treesitter.start()
```

Neovim 0.9+ 自动启用 treesitter 高亮。在 `FileType` autocmd 中手动调用 `vim.treesitter.start()` 会导致重复启动，无实际作用但增加开销。

**建议**：删除这行。

---

### 7. `aftercare.lua` 的执行顺序问题

**文件**: `lua/aftercare.lua`（第 3 行）和 `init.lua`（第 164 行）

```lua
-- aftercare.lua:
require("telescope").load_extension("persisted")
```

`aftercare.lua` 在 `init.lua` 中加载（第 164 行），早于 `after/plugin/configs.lua` 中的 `require("config.telescope")`。这意味着 Telescope 的 `load_extension("persisted")` 在 Telescope 被 setup 之前执行。

**建议**：将 `telescope.load_extension("persisted")` 移到 `lua/config/telescope.lua` 的 setup 之后。

---

### 8. `snacks/bigfile.lua` 注释与实际值不匹配

**文件**: `lua/config/snacks/bigfile.lua`，第 5 行

```lua
size = 5 * 1024 * 1024, -- 1.5MB
```

`5 * 1024 * 1024 = 5MB`，不是 1.5MB。注释与实际值不一致。

**建议**：修正注释为 `-- 5MB`，或改为 `1.5 * 1024 * 1024`。

---

### 9. `telescope.lua` 缺少 `telescope.setup()` 调用

**文件**: `lua/config/telescope.lua`

整个配置中没有显式调用 `telescope.setup({})`。Telescope 可能用默认配置工作，但某些功能（如 border、theme、mappings 等）需要通过 `setup()` 配置。

**建议**：添加 `telescope.setup({...})` 调用。

---

### 10. Copilot 与 blink.cmp 的 Tab 键冲突

**文件**: `lua/config/copilot.lua`（第 12 行）和 `after/plugin/blink-cmp.lua`

```lua
-- copilot.lua:
accept = '<Tab>',

-- blink-cmp.lua:
preset = "super-tab",
```

两个插件都消费 `Tab` 键。MIGRATION.md 提到 blink 的 `fallback` 优先，但这取决于事件处理顺序，并不可靠。

**建议**：
- 方案 A：Copilot 改用其他键（如 `<C-j>` 或 `<Right>`）
- 方案 B：在 blink 配置中显式处理 copilot 建议的优先级

---

## 🟢 轻微问题

### 11. `toggleterm.lua` 中的旧式 autocmd 和全局函数

**文件**: `lua/config/toggleterm.lua`，第 35、50 行

```lua
function _G.set_terminal_keymaps()
  -- ...
end

vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
```

与其他配置文件中使用的 `vim.api.nvim_create_autocmd` 风格不一致。`_G` 全局函数也不是推荐的做法。

**建议**：改用 `vim.api.nvim_create_autocmd`，将函数直接内联。

---

### 12. `keymaps.lua` 中 `mapleader` 设置顺序

**文件**: `lua/keymaps.lua`，第 10-12 行

```lua
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
```

第 10 行的映射本身不依赖 `mapleader`，所以没问题。但如果未来在之前映射使用 `<leader>`，就会读到旧的 `mapleader`。按惯例 `mapleader` 应最早设置。

**建议**：将 `vim.g.mapleader` 移到文件最顶部，在第 10 行的 `<Nop>` 映射之前。

---

### 13. 安装了三个功能重叠的模糊查找器

**文件**: `init.lua`，第 104-106、135-136 行

同时安装了：
- `telescope.nvim` + `telescope-fzf-native.nvim`
- `fzf-lua`
- `mini.pick`

Telescope 和 fzf-lua 功能高度重叠，同时安装只会增加启动时间和维护负担。mini.pick 更轻量但也存在重叠。

**建议**：选择其中一个作为主力（推荐保留 Telescope，你已经深度配置了它），移除其余。

---

### 14. `telescope.lua` 键位映射风格不一致

**文件**: `lua/config/telescope.lua`，第 27-28 行

```lua
vim.keymap.set("n", "<leader>pe", ":Telescope persisted<CR>", {})
vim.keymap.set("n", "<leader>rg", ":Telescope live_grep<CR>", {})
```

其余映射（第 11-24 行）使用 `builtin.xxx` Lua 函数调用，但这两行回退到 `:Telescope` vim 命令字符串。风格不统一。

**建议**：统一使用 `builtin.xxx` 风格：

```lua
vim.keymap.set("n", "<leader>rg", builtin.live_grep, {})
```

---

### 15. `.luarc.json` 可补充更多全局变量

**文件**: `.luarc.json`

```json
{
    "diagnostics.globals": [
        "vim"
    ]
}
```

缺少 Neovim 测试中常用的全局变量（如果写测试的话），如 `describe`、`it`、`before_each` 等。

**建议**（可选）：

```json
{
    "diagnostics.globals": [
        "vim",
        "describe",
        "it",
        "before_each",
        "after_each"
    ]
}
```

---

### 16. `nt.install()` 是过时 API

**文件**: `lua/config/nvim-treesitter.lua`，第 8 行

```lua
nt.install({"c", "cpp", ...})
```

新版 nvim-treesitter 推荐在 `setup()` 中通过 `ensure_installed` 配置项声明需要安装的 parser。

**建议**：

```lua
nt.setup({
    ensure_installed = { "c", "cpp", "cmake", "javascript", "lua", ... }
})
```

移除单独的 `nt.install()` 调用。

---

## 📊 总结

| 严重度 | 数量 | 关键项 |
|--------|------|--------|
| 🔴 严重 | 4 | `.gitignore` 排除锁文件、dap 崩溃 bug、dapui 重复 setup、blink 每次启动构建 |
| 🟡 中等 | 6 | formatoptions 格式损坏、过时 API 调用、执行顺序错误、注释与值不匹配、缺少 setup、Tab 键冲突 |
| 🟢 轻微 | 6 | 风格不一致、重复插件、mapleader 顺序、autocmd 风格、全局函数、过时 API |

**优先修复建议**：

1. 修复 `.gitignore`，确保 `nvim-pack-lock.json` 和 `.luarc.json` 被跟踪
2. 修复 `dap.lua` 的 `and` → `or` 逻辑错误
3. 清理 `dapui.setup()` 的三次调用
4. 移除 `init.lua` 中每次启动的 blink 构建
5. 修正 `options.lua` 中的格式损坏
6. 移除 `vim.treesitter.start()` 过时调用

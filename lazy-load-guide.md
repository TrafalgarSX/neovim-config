# vim.pack.add() 延迟加载指南

## 背景

`vim.pack.add()` 默认对所有插件调用 `:packadd!`（`load = false`），导致所有 opt 插件的
`plugin/` 文件在启动时全部加载。通过自定义 `load` 函数，可以让重型 / 不常用的插件
延迟到需要时才加载，从而减少启动时间。

## 核心机制

### `vim.pack.add()` 的 `load` 参数

| `load` 值 | 行为 |
|-----------|------|
| `false`（默认） | 对每个插件执行 `:packadd!`，插件被加载，plugin/ 被 source |
| 自定义函数 | 完全替代 `:packadd!`，函数体为空 = 插件不加载 |

### 延迟加载策略

本配置通过自定义 `load` 函数，在插件**首次被需要时**才调用 `vim.cmd.packadd()`。
支持两种加载方式：

1. **始终加载** — 启动必需、轻量的插件直接用一个 `vim.pack.add()` 加载
2. **延迟加载** — 重型 / 不常用的插件通过 `lazy_load()` 包装，
   由 event / keys / cmd 三种触发器按需加载

---

## 配置结构

### init.lua 中的 `lazy_load()` 函数

```lua
local group = vim.api.nvim_create_augroup("LazyPlugins", { clear = true })

local function lazy_load(plugins)
  vim.pack.add(plugins, {
    load = function(plugin)
      local data = plugin.spec.data or {}

      -- Event trigger：特定 autocmd 事件触发
      if data.event then
        vim.api.nvim_create_autocmd(data.event, {
          group = group,
          once = true,
          pattern = data.pattern or "*",
          callback = function()
            vim.cmd.packadd(plugin.spec.name)
            if data.config then
              data.config()
            end
          end,
        })
      end

      -- Keymap trigger：首次按键触发
      if data.keys then
        local mode, lhs = data.keys[1], data.keys[2]
        vim.keymap.set(mode, lhs, function()
          vim.keymap.del(mode, lhs)          -- 删除占位映射
          vim.cmd.packadd(plugin.spec.name)
          if data.config then
            data.config()
          end
          -- 重新触发原按键序列
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes(lhs, true, false, true),
            "m", false
          )
        end, { desc = data.desc })
      end

      -- Command trigger：首次执行命令触发
      if data.cmd then
        vim.api.nvim_create_user_command(data.cmd, function(cmd_args)
          pcall(vim.api.nvim_del_user_command, data.cmd)
          vim.cmd.packadd(plugin.spec.name)
          if data.config then
            data.config()
          end
          -- 重新执行原命令，传递所有参数
          vim.api.nvim_cmd({
            cmd = data.cmd,
            args = cmd_args.fargs,
            bang = cmd_args.bang,
            nargs = cmd_args.nargs,
            range = cmd_args.range ~= 0
              and { cmd_args.line1, cmd_args.line2 }
              or nil,
            count = cmd_args.count ~= -1 and cmd_args.count or nil,
          }, {})
        end, {
          nargs = data.nargs,
          range = data.range,
          bang = data.bang,
          complete = data.complete,
          count = data.count,
        })
      end
    end,
  })
end
```

### `data` 字段说明

| 字段 | 类型 | 说明 |
|------|------|------|
| `event` | `string[]` | autocmd 事件名，如 `{"BufRead", "BufNewFile"}` |
| `pattern` | `string[]` | autocmd 的文件匹配模式，如 `{"*.cmake", "CMakeLists.txt"}` |
| `keys` | `{mode, lhs}` | 触发按键，如 `{"n", "<leader>ng"}` |
| `cmd` | `string` | 触发命令名，如 `"AvanteAsk"` |
| `config` | `function` | 插件加载后的配置回调 |
| `desc` | `string` | 按键的描述文本 |
| `nargs`, `range`, `bang`, `complete`, `count` | 任意 | 传递给 `nvim_create_user_command` 的参数 |

---

## 当前延迟加载配置

### 始终加载的插件

```lua
vim.pack.add({
  -- Completion
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*") },
  "https://github.com/saghen/blink.lib",
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/Kaiser-Yang/blink-cmp-avante",

  -- LSP / Mason
  "https://github.com/neovim/nvim-lspconfig",
  { src = "https://github.com/mason-org/mason.nvim", version = vim.version.range("*") },
  "https://github.com/mason-org/mason-lspconfig.nvim",

  -- Treesitter
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },

  -- UI
  "https://github.com/folke/snacks.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/navarasu/onedark.nvim",
  "https://github.com/sainnhe/sonokai",
  "https://github.com/sainnhe/everforest",
  "https://github.com/sainnhe/gruvbox-material",
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/tanvirtin/monokai.nvim",

  -- Fuzzy finder
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",

  -- Editing / motions
  "https://github.com/windwp/nvim-autopairs",
  { src = "https://github.com/kylechui/nvim-surround", version = vim.version.range("4.x") },
  "https://github.com/numToStr/Comment.nvim",
  "https://github.com/folke/flash.nvim",

  -- Diagnostics
  { src = "https://github.com/folke/trouble.nvim", version = "main" },

  -- Copilot
  "https://github.com/zbirenbaum/copilot.lua",

  -- Debug (async lib + dap)
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/mfussenegger/nvim-dap-python",

  -- Misc
  "https://github.com/stevearc/aerial.nvim",
  "https://github.com/mikavilpas/yazi.nvim",
  { src = "https://github.com/stevearc/conform.nvim", version = vim.version.range("*") },
  "https://github.com/olimorris/persisted.nvim",
  "https://github.com/sindrets/diffview.nvim",

  -- IM select
  "https://github.com/keaising/im-select.nvim",

  -- Avante dependencies (avante 自身见下方延迟加载)
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/stevearc/dressing.nvim",
  "https://github.com/HakonHarnes/img-clip.nvim",
})
```

### 延迟加载的插件

```lua
lazy_load({
  -- cmake-tools：打开 CMake 文件时才加载
  {
    src = "https://github.com/Civitasv/cmake-tools.nvim",
    data = {
      event = { "BufRead", "BufNewFile" },
      pattern = { "*.cmake", "CMakeLists.txt" },
      config = function()
        require("config.cmake")
      end,
    },
  },

  -- obsidian：打开 Markdown 文件时才加载
  {
    src = "https://github.com/obsidian-nvim/obsidian.nvim",
    version = vim.version.range("*"),
    data = {
      event = { "BufRead", "BufNewFile" },
      pattern = { "*.md" },
      config = function()
        require("config.obsidian")
      end,
    },
  },

  -- gitsigns：打开文件时才加载
  {
    src = "https://github.com/lewis6991/gitsigns.nvim",
    data = {
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("config.gitsigns")
      end,
    },
  },

  -- neogit：按 <leader>ng 才加载
  {
    src = "https://github.com/NeogitOrg/neogit",
    version = vim.version.range("*"),
    data = {
      keys = { "n", "<leader>ng" },
      config = function()
        require("neogit").setup({})
        -- 重建映射，第二次按键起直接调用 Neogit
        vim.keymap.set("n", "<leader>ng", "<cmd>Neogit<CR>",
          { desc = "Open Neogit" })
      end,
    },
  },

  -- avante.nvim：执行 :AvanteAsk 才加载
  {
    src = "https://github.com/yetone/avante.nvim",
    data = {
      cmd = "AvanteAsk",
      config = function()
        require("config.avante")
      end,
    },
  },
})
```

### 延迟加载时机一览

| 插件 | 触发方式 | 首次加载时机 |
|------|----------|-------------|
| cmake-tools.nvim | Event `BufRead`/`BufNewFile` | 打开 `CMakeLists.txt` 或 `*.cmake` |
| obsidian.nvim | Event `BufRead`/`BufNewFile` | 打开 `*.md` |
| gitsigns.nvim | Event `BufReadPre`/`BufNewFile` | 打开任何文件 |
| neogit | Keys `<leader>ng` | 首次按下 |
| avante.nvim | Cmd `AvanteAsk` | 首次执行 `:AvanteAsk` |

---

## after/plugin/configs.lua 结构

```lua
if vim.g.vscode then return end

-- ═══════════════════════════════════════════════════════════════
-- Eager：首屏必须的配置
-- ═══════════════════════════════════════════════════════════════
require("snacks").setup(require("config.snacks"))
require("config.lualine")
require("config.bufferline")
require("config.nvim-autopairs")
require("config.flash")
require("config.nvim-treesitter")
require("config.nvim-treesitter-textobjects")
require("config.trouble")
require("config.conform")
require("Comment").setup()
require("im_select").setup({})

-- ═══════════════════════════════════════════════════════════════
-- Deferred：dashboard 之后才需要的配置
-- ═══════════════════════════════════════════════════════════════
vim.schedule(function()
  require("config.nvim-tree")
  require("config.telescope")
  require("config.copilot")
  require("config.dap")
  require("config.dappy")
  require("config.persisted")
  require("aerial").setup({})
  require("yazi").setup({
    open_for_directories = false,
    keymaps = { show_help = "<f1>" },
  })
  require("img-clip").setup({
    default = {
      embed_image_as_base64 = false,
      prompt_for_file_name = false,
      drag_and_drop = { insert_mode = true },
      use_absolute_path = true,
    },
  })
end)
```

注意：延迟加载的插件（cmake-tools、obsidian、gitsigns、neogit、avante）不在
after/plugin/ 中配置——它们的 config 回调在 `lazy_load()` 的 `data.config` 中定义。

---

## 扩展示例

### 添加带有条件的延迟加载（如只在 git 仓库中加载 gitsigns）

给 `lazy_load()` 的 event 部分扩展 `condition` 字段：

```lua
-- Event trigger（修改版，支持 condition）
if data.event then
  vim.api.nvim_create_autocmd(data.event, {
    group = group,
    pattern = data.pattern or "*",
    callback = function(args)
      -- 条件不满足时跳过，保留 autocmd 等待下次触发
      if data.condition and not data.condition(args) then
        return
      end
      vim.api.nvim_del_autocmd(args.id)  -- 手动删除，相当于 once
      vim.cmd.packadd(plugin.spec.name)
      if data.config then data.config() end
    end,
  })
end
```

使用：

```lua
{
  src = "https://github.com/lewis6991/gitsigns.nvim",
  data = {
    event = { "BufReadPre", "BufNewFile" },
    condition = function(args)
      return vim.fs.root(args.buf, ".git") ~= nil
    end,
    config = function()
      require("config.gitsigns")
    end,
  },
}
```

### 添加按键触发的插件

```lua
{
  src = "https://github.com/xxx/yyy.nvim",
  data = {
    keys = { "n", "<leader>xx" },
    desc = "Open YYY",
    config = function()
      require("config.yyy")
      -- 重建映射供下次直接调用
      vim.keymap.set("n", "<leader>xx", ":YYY<CR>", { desc = "Open YYY" })
    end,
  },
}
```

按键触发流程：首次按键 → 删除占位映射 → packadd + config → feedkeys 重新触发
→ config 中重建的映射生效。

### 添加命令触发的插件

```lua
{
  src = "https://github.com/xxx/zzz.nvim",
  data = {
    cmd = "MyCommand",
    nargs = "*",
    bang = true,
    config = function()
      require("config.zzz")
    end,
  },
}
```

命令触发流程：首次执行 `:MyCommand` → 删除占位命令 → packadd + config
→ 重新执行原命令（传递所有参数和修饰符），此时插件提供真正的命令实现。

---

## 测试方法

```bash
# 测试启动时间
nvim --startuptime temp +q

# 查看延迟加载的插件是否已加载
:lua =vim.pack.get()

# 手动加载某个延迟插件
:packadd <plugin-name>
```

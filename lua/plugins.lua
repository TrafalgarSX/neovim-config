-- Install Lazy.nvim automatically if it's not installed(Bootstraping)
-- Hint: string concatenation is done by `..`
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- After installation, run `checkhealth lazy` to see if everything goes right
-- Hints:
--     build: It will be executed when a plugin is installed or updated
--     config: It will be executed when the plugin loads
--     event: Lazy-load on event
--     dependencies: table
--                   A list of plugin names or plugin specs that should be loaded when the plugin loads.
--                   Dependencies are always lazy-loaded unless specified otherwise.
--     ft: Lazy-load on filetype
--     cmd: Lazy-load on command
--     init: Functions are always executed during startup
--     branch: string?
--             Branch of the repository
--     main: string?
--           Specify the main module to use for config() or opts()
--           , in case it can not be determined automatically.
--     keys: string? | string[] | LazyKeysSpec table
--           Lazy-load on key mapping
--     opts: The table will be passed to the require(...).setup(opts)
require("lazy").setup({
  -- LSP manager
  {
    "mason-org/mason.nvim",
    event = "VeryLazy",
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = "VeryLazy",
  },
  {
    "neovim/nvim-lspconfig",
  },
  -- Auto-completion engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp", -- lsp auto-completion
      "hrsh7th/cmp-buffer",   -- buffer auto-completion
      "hrsh7th/cmp-path",     -- path auto-completion
      "hrsh7th/cmp-cmdline",  -- cmdline auto-completion
    },
    config = function()
      require("config.nvim-cmp")
    end,
  },
  -- Code snippet engine
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    version = "v2.*",
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      stages = "static",
    },
  },
  -- Better UI
  -- Run `:checkhealth noice` to check for common issues
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- Add any options here
    },
    dependencies = {
      -- If you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
  -- Git integration
  "tpope/vim-fugitive",
  -- Git decorations
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("config.gitsigns")
    end,
  },
  -- Autopairs: [], (), "", '', etc
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("config.nvim-autopairs")
    end,
  },
  -- Treesitter-integration
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("config.nvim-treesitter")
    end,
  },
  -- Nvim-treesitter text objects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("config.nvim-treesitter-textobjects")
    end,
  },
  -- Show indentation and blankline
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("config.indent-blankline")
    end,
  },
  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.lualine")
    end,
  },
  -- Markdown support
  {
    "preservim/vim-markdown",
    ft = { "markdown" },
  },
  -- Markdown previewer
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    config = function()
      require("config.nvim-tree")
    end,
  },
  -- Smart motion
  {
    "smoka7/hop.nvim",
    version = "*",
    opts = {
      keys = "etovxqpdygfblzhckisuran",
    },
  },
  -- Make surrounding easier
  -- ------------------------------------------------------------------
  -- Old text                    Command         New text
  -- ------------------------------------------------------------------
  -- surr*ound_words             gziw)           (surround_words)
  -- *make strings               gz$"            "make strings"
  -- [delete ar*ound me!]        gzd]            delete around me!
  -- remove <b>HTML t*ags</b>    gzdt            remove HTML tags
  -- 'change quot*es'            gzc'"           "change quotes"
  -- delete(functi*on calls)     gzcf            function calls
  -- ------------------------------------------------------------------
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    -- You can use the VeryLazy event for things that can
    -- load later and are not important for the initial UI
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- To solve the conflicts with leap.nvim
        -- See: https://github.com/ggandor/leap.nvim/discussions/59
        keymaps = {
          insert = "<C-g>z",
          insert_line = "gC-ggZ",
          normal = "gz",
          normal_cur = "gZ",
          normal_line = "gzgz",
          normal_cur_line = "gZgZ",
          visual = "gz",
          visual_line = "gZ",
          delete = "gzd",
          change = "gzc",
        },
      })
    end,
  },
  -- Better terminal integration
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("config.toggleterm")
    end,
  },
  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("config.telescope")
    end,
  },
  -- Colorscheme
  {
    "tanvirtin/monokai.nvim",
  },
  {
    "navarasu/onedark.nvim",
  },
  {
    "sainnhe/sonokai",
  },
  "sainnhe/everforest",
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = "soft"
      vim.g.gruvbox_material_foreground = "mix"
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_dim_inactive_windows = 1
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_current_word = "high contrast background"
    end,
  },
  {
    "folke/tokyonight.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {},
  },
  {
    "keaising/im-select.nvim",
    config = function()
      require("im_select").setup({})
    end,
  },
  -- Improve the performance of big file
  {
    "LunarVim/bigfile.nvim",
  },

  {
    "folke/trouble.nvim",
    branch = "main",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<leader>dt",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>df",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>ll",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>ql",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
    opts = function()
      require("config.trouble")
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("config.copilot")
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "goolord/alpha-nvim",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      require("alpha").setup(require("alpha.themes.startify").config)
    end,
  },
  -- cmake-tools like vscode
  {
    "Civitasv/cmake-tools.nvim",
    event = "BufRead CMakeLists.txt",
    config = function()
      require("config.cmake")
    end,
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
      require("config.dap")
    end,
  },

  -- Debugger user interface
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
      require("config.conform")
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      require("config.dappy")
    end,
  },
  {
    "stevearc/aerial.nvim",
    event = "VeryLazy",
    opts = {},
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  -- add this to your lua/plugins.lua, lua/plugins/init.lua,  or the file you keep your other plugins:
  {
    "numToStr/Comment.nvim",
    opts = {
      -- add any options here
    },
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
  },
  {
    -- easymotion like
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
    config = function()
      require("config.flash")
    end
  },
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      keymaps = {
        show_help = '<f1>',
      },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua",              -- optional
      "echasnovski/mini.pick",         -- optional
    },
    config = true,
    event = "VeryLazy",
  },
  {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("config.bufferline")
    end
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/opilot.vim
      { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    build = "make tiktoken",        -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- 永远不要将此值设置为 "*"！永远不要！
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- 在此处添加任何选项
      -- 例如
      provider = "copilot",
    },
    -- 如果您想从源代码构建，请执行 `make BUILD_FROM_SOURCE=true`
    -- build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- 对于 Windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",

      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- 以下依赖项是可选的，
      "echasnovski/mini.pick",         -- 用于文件选择器提供者 mini.pick
      "nvim-telescope/telescope.nvim", -- 用于文件选择器提供者 telescope
      "hrsh7th/nvim-cmp",              -- avante 命令和提及的自动完成
      "ibhagwan/fzf-lua",              -- 用于文件选择器提供者 fzf
      "nvim-tree/nvim-web-devicons",   -- 或 echasnovski/mini.icons
      "zbirenbaum/copilot.lua",        -- 用于 providers='copilot'
      {
        -- 如果您有 lazy=true，请确保正确设置
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  }
})

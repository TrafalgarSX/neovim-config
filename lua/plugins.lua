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
	-- lazy.nvim
	-- 在这里添加 snacks.nvim 的配置
	{
		"folke/snacks.nvim",
		opts = require("config.snacks"),
	},
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
			"hrsh7th/cmp-buffer", -- buffer auto-completion
			"hrsh7th/cmp-path", -- path auto-completion
			"hrsh7th/cmp-cmdline", -- cmdline auto-completion
		},
		config = function()
			require("config.nvim-cmp")
		end,
	},
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
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("config.nvim-treesitter")
		end,
	},
	-- Nvim-treesitter text objects
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true
		end,
		config = function()
			require("config.nvim-treesitter-textobjects")
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
	--     Old text                    Command         New text
	-- --------------------------------------------------------------------------------
	--     surr*ound_words             ysiw)           (surround_words)
	--     surr*ound_words             ysiw(           ( surround_words )
	--     *make strings               ys$"            "make strings"
	--     [delete ar*ound me!]        ds]             delete around me!
	--     remove <b>HTML t*ags</b>    dst             remove HTML tags
	--     'change quot*es'            cs'"            "change quotes"
	--     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
	--     delete(functi*on calls)     dsf             function calls
	{
		"kylechui/nvim-surround",
		version = "^4.0.0", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
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
			vim.g.gruvbox_material_background = "medium"
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
		"mfussenegger/nvim-dap-python",
		lazy = true,
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
		end,
	},
	{
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		opts = {
			-- if you want to open yazi instead of netrw, see below for more info
			open_for_directories = false,
			keymaps = {
				show_help = "<f1>",
			},
		},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
			"echasnovski/mini.pick", -- optional
		},
		config = true,
		event = "VeryLazy",
	},
	{
		"akinsho/bufferline.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("config.bufferline")
		end,
	},
	-- {
	-- "CopilotC-Nvim/CopilotChat.nvim",
	-- branch = "main",
	-- dependencies = {
	--   { "zbirenbaum/copilot.lua" }, -- or github/opilot.vim
	--   { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
	-- },
	-- build = "make tiktoken",        -- Only on MacOS or Linux
	--   opts = {
	--     -- See Configuration section for options
	--   },
	-- },
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		ft = { "markdown", "quarto" },
		config = function()
			require("config.obsidian")
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("config.conform")
		end,
	},
	{
		"olimorris/persisted.nvim",
		event = "BufReadPre",
		config = function()
			require("config.persisted")
		end,
	},
	{
		"yetone/avante.nvim",
		-- 如果您想从源代码构建，请执行 `make BUILD_FROM_SOURCE=true`
		-- ⚠️ 一定要加上这一行配置！！！！！
		build = vim.fn.has("win32") ~= 0
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		event = "VeryLazy",
		version = false, -- 永远不要将此值设置为 "*"！永远不要！
		opts = {
			-- 在此处添加任何选项
			-- 例如
			input = { provider = "dressing" },
			provider = "deepseek",
			providers = {
				deepseek = {
					__inherited_from = "openai",
					api_key_name = "DEEPSEEK_API_KEY",
					endpoint = "https://api.deepseek.com",
					model = "deepseek-v4-pro",
					extra_request_body = {
						max_tokens = 300000,
						thinking = { type = "enabled" },
					},
				},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- 以下依赖项是可选的，
			"echasnovski/mini.pick", -- 用于文件选择器提供者 mini.pick
			"nvim-telescope/telescope.nvim", -- 用于文件选择器提供者 telescope
			"hrsh7th/nvim-cmp", -- avante 命令和提及的自动完成
			"ibhagwan/fzf-lua", -- 用于文件选择器提供者 fzf
			"nvim-tree/nvim-web-devicons", -- 或 echasnovski/mini.icons
			"folke/snacks.nvim", -- 确保 snacks 先加载
			"stevearc/dressing.nvim", -- for input provider dressing
			{
				-- 支持图像粘贴
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- 推荐设置
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- Windows 用户必需
						use_absolute_path = true,
					},
				},
			},
		},
	},
})

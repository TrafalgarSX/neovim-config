vim.loader.enable()
require("options")
require("keymaps")

-- VSCode branch: return early to skip all regular-Neovim-only plugins and config below.
-- The 5 plugins listed here are also in the main vim.pack.add() list (lines ~90),
-- so regular Neovim loads them too — no duplication concern.
if vim.g.vscode then
	vim.pack.add({
		{ src = "https://github.com/kylechui/nvim-surround", version = vim.version.range("4.x") },
		"https://github.com/numToStr/Comment.nvim",
		"https://github.com/folke/flash.nvim",
		"https://github.com/keaising/im-select.nvim",
		{ src = "https://github.com/stevearc/conform.nvim", version = vim.version.range("*") },
	})

	require("Comment").setup()
	require("im_select").setup({})
	require("config.conform")
	require("config.flash")
	return -- <-- everything below is skipped in VSCode
end

-- ── PackChanged hooks ─────────────────────────────────────────────
-- Runs after plugin install/update/delete. Handles post-install builds.
local pack_hooks_group = vim.api.nvim_create_augroup("PackHooks", { clear = true })
vim.api.nvim_create_autocmd("PackChanged", {
	group = pack_hooks_group,
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		local is_install = kind == "install" or kind == "update"

		-- Ensure opt plugin is on the runtime path before we try to use it
		local function ensure_active()
			if not ev.data.active then
				vim.cmd.packadd(name)
			end
		end

		if name == "nvim-treesitter" and is_install then
			ensure_active()
			vim.cmd("TSUpdate")
		elseif name == "blink.cmp" and is_install then
			ensure_active()
			local ok, blink = pcall(require, "blink.cmp")
			if ok and type(blink.build) == "function" then
				blink.build():wait(60000)
			end
		-- elseif name == "avante.nvim" and kind == "install" then
		elseif name == "avante.nvim" and is_install then
			if vim.fn.has("win32") == 1 then
				vim.fn.system({
					"powershell",
					"-ExecutionPolicy",
					"Bypass",
					"-File",
					"Build.ps1",
					"-BuildFromSource",
					"false",
				})
			else
				vim.fn.system({ "make" })
			end
		elseif name == "telescope-fzf-native.nvim" and is_install then
			ensure_active()
			local fzf_dir = vim.fn.stdpath("data") .. "/pack/core/opt/telescope-fzf-native.nvim"
			if vim.fn.has("win32") == 1 then
				vim.fn.system({ "cmake", "-S", fzf_dir, "-B", fzf_dir .. "/build", "-DCMAKE_BUILD_TYPE=Release" })
				vim.fn.system({ "cmake", "--build", fzf_dir .. "/build", "--config", "Release" })
			else
				vim.fn.system({ "make", "-C", fzf_dir })
			end
		end
	end,
})

-- ═══════════════════════════════════════════════════════════════════════
-- 始终加载的插件（启动必需的轻量插件）
-- ═══════════════════════════════════════════════════════════════════════
vim.pack.add({
	-- Completion: blink.cmp (replaces nvim-cmp)
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

	-- Diagnostics / Trouble
	{ src = "https://github.com/folke/trouble.nvim", version = "main" },

	-- Copilot
	"https://github.com/zbirenbaum/copilot.lua",

	-- dap 插件使用的异步库
	"https://github.com/nvim-neotest/nvim-nio",

	-- Debugging
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/mfussenegger/nvim-dap-python",

	-- Misc
	"https://github.com/stevearc/aerial.nvim", -- code outline
	{ src = "https://github.com/mikavilpas/yazi.nvim", version = vim.version.range("*") },
	{ src = "https://github.com/stevearc/conform.nvim", version = vim.version.range("*") },
	"https://github.com/olimorris/persisted.nvim",
	"https://github.com/sindrets/diffview.nvim",

	-- IM select
	"https://github.com/keaising/im-select.nvim",

	-- Avante.nvim (AI)
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/stevearc/dressing.nvim",
	"https://github.com/HakonHarnes/img-clip.nvim",

	-- 纠正习惯，依赖于  nui.nvim
	"https://github.com/m4xshen/hardtime.nvim",
})

-- ═══════════════════════════════════════════════════════════════════════
-- 延迟加载的插件（重型 / 不常用）
-- ═══════════════════════════════════════════════════════════════════════
local group = vim.api.nvim_create_augroup("LazyPlugins", { clear = true })

-- nvim 懒加载参考
-- https://www.reddit.com/r/neovim/comments/1mx71rc/how_i_vastly_improved_my_lazy_loading_experience/---@param plugins (string|vim.pack.Spec)[]
local function lazy_load(plugins)
	vim.pack.add(plugins, {
		load = function(plugin)
			local data = plugin.spec.data or {}

			-- Event trigger
			if data.event then
				vim.api.nvim_create_autocmd(data.event, {
					group = group,
					pattern = data.pattern or "*",
					callback = function(args)
						-- 条件检查：如果提供了 condition 但不满足，跳过
						if data.condition and not data.condition(args) then
							return -- 不加载，保留 autocmd 等下次
						end
						vim.api.nvim_del_autocmd(args.id) -- 手动删除，相当于 once
						vim.cmd.packadd(plugin.spec.name)
						if data.config then
							data.config(plugin)
						end
					end,
				})
			end

			-- Keymap trigger
			if data.keys then
				local mode, lhs = data.keys[1], data.keys[2]
				vim.keymap.set(mode, lhs, function()
					vim.keymap.del(mode, lhs)
					vim.cmd.packadd(plugin.spec.name)
					if data.config then
						data.config(plugin)
					end
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(lhs, true, false, true), "m", false)
				end, { desc = data.desc })
			end

			-- Command trigger
			if data.cmd then
				vim.api.nvim_create_user_command(data.cmd, function(cmd_args)
					pcall(vim.api.nvim_del_user_command, data.cmd)
					vim.cmd.packadd(plugin.spec.name)
					if data.config then
						data.config(plugin)
					end
					vim.api.nvim_cmd({
						cmd = data.cmd,
						args = cmd_args.fargs,
						bang = cmd_args.bang,
						nargs = cmd_args.nargs,
						range = cmd_args.range ~= 0 and { cmd_args.line1, cmd_args.line2 } or nil,
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

lazy_load({
	{
		src = "https://github.com/Civitasv/cmake-tools.nvim",
		data = {
			event = { "BufRead", "BufNewFile" },
			pattern = { "*.cmake", "CMakeLists.txt" },
			config = function(name)
				require("config.cmake")
			end,
		},
	},
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
	},
	{
		src = "https://github.com/NeogitOrg/neogit",
		version = vim.version.range("*"),
		data = {
			keys = { "n", "<leader>ng" },
			config = function()
				require("neogit").setup({})
				vim.keymap.set("n", "<leader>ng", "<cmd>Neogit<CR>", { desc = "Open Neogit" })
			end,
		},
	},
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

-- ── Early configuration (before after/plugin/ scripts) ────────────
require("colorscheme")
-- Mason + LSP 延迟到 UI 渲染后加载
vim.schedule(function()
	require("lsp_utils")
	require("lspconfigs")
	require("lsp")
end)

-- Diagnostic UI (sign symbols in the gutter)
vim.diagnostic.config({
	virtual_text = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "󰋼",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},
})

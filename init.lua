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
		"https://github.com/stevearc/conform.nvim",
	})

	require("Comment").setup()
	require("im_select").setup({})
	require("config.conform")
	require("flash").setup()
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
		elseif name == "avante.nvim" and kind == "install" then
			if vim.fn.has("win32") == 1 then
				vim.fn.system({ "powershell", "-ExecutionPolicy", "Bypass", "-File", "Build.ps1", "-BuildFromSource", "false" })
			else
				vim.fn.system({ "make" })
			end
		elseif name == "telescope-fzf-native.nvim" and is_install then
			ensure_active()
			local fzf_dir = vim.fn.stdpath("data") .. "/pack/core/opt/telescope-fzf-native.nvim"
			if vim.fn.has("win32") == 1 then
				vim.fn.system({ "cmake", "-S", fzf_dir, "-B", fzf_dir .. "/build",
					"-DCMAKE_BUILD_TYPE=Release" })
				vim.fn.system({ "cmake", "--build", fzf_dir .. "/build", "--config", "Release" })
			else
				vim.fn.system({ "make", "-C", fzf_dir })
			end
		end
	end,
})

-- ── Load all plugins ───────────────────────────────────────────────
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

	-- Git
	"https://github.com/lewis6991/gitsigns.nvim",
	{ src = "https://github.com/NeogitOrg/neogit", version = vim.version.range("*") },
	"https://github.com/sindrets/diffview.nvim",

	-- Fuzzy finder
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",

	-- Editing / motions
	"https://github.com/windwp/nvim-autopairs",
	{ src = "https://github.com/kylechui/nvim-surround", version = vim.version.range("4.x") },
	"https://github.com/numToStr/Comment.nvim",
	"https://github.com/folke/flash.nvim",

	-- Terminal
	{ src = "https://github.com/akinsho/toggleterm.nvim", version = vim.version.range("*") },

	-- Diagnostics / Trouble
	{ src = "https://github.com/folke/trouble.nvim", version = "main" },

	-- Copilot
	"https://github.com/zbirenbaum/copilot.lua",

	-- CMake
	"https://github.com/Civitasv/cmake-tools.nvim",

	-- Debugging
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/mfussenegger/nvim-dap-python",
	"https://github.com/nvim-neotest/nvim-nio",

	-- Misc
	"https://github.com/stevearc/aerial.nvim",
	"https://github.com/mikavilpas/yazi.nvim",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/echasnovski/mini.pick",
	{ src = "https://github.com/obsidian-nvim/obsidian.nvim", version = vim.version.range("*") },
	{ src = "https://github.com/stevearc/conform.nvim", version = vim.version.range("*") },
	"https://github.com/olimorris/persisted.nvim",

	-- IM select
	"https://github.com/keaising/im-select.nvim",

	-- Avante.nvim (AI)
	"https://github.com/yetone/avante.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/stevearc/dressing.nvim",
	"https://github.com/HakonHarnes/img-clip.nvim",
})

-- ── Early configuration (before after/plugin/ scripts) ────────────
require("lsp_utils")
require("lspconfigs")
require("lsp")
require("colorscheme")

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

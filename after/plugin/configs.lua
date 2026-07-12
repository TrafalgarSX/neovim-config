if vim.g.vscode then
	return
end

-- ── Eager setup: needed for the initial screen / first keystroke ──

require("vim._core.ui2").enable({})
-- Dashboard (must render first)
require("snacks").setup(require("config.snacks"))

-- Statusline / tabline (visible immediately)
require("config.lualine")
require("config.bufferline")

-- Editing (needed before first keystroke)
require("config.nvim-autopairs")
require("config.flash")
require("config.mini-jump2d")

-- Treesitter (syntax highlighting from first buffer)
require("config.nvim-treesitter")
require("config.nvim-treesitter-textobjects")

-- Diagnostics
require("config.trouble")

-- Formatting
require("config.conform")

-- nvimn-surround
require("config.nvim-surround")

-- Lightweight, no-setup plugins
require("config.hardtime")
require("Comment").setup()
require("im_select").setup({})
-- ── Deferred setup: not needed for the dashboard ──
vim.schedule(function()
	-- UI (file tree, fuzzy finder)
	require("config.nvim-tree")
	require("config.telescope")

	-- Completion / AI
	require("config.copilot")

	-- Project-specific tools
	require("config.dap")
	require("config.dappy")
	require("config.persisted")

	-- Misc
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

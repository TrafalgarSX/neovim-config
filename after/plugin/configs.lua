-- Plugin configurations (auto-sourced by Neovim after vim.pack.add() in init.lua)

-- UI
require("snacks").setup(require("config.snacks"))
require("config.lualine")
require("config.nvim-tree")
require("config.bufferline")
require("config.telescope")
require("config.trouble")

-- Editing
require("config.nvim-autopairs")
require("config.flash")
require("config.gitsigns")

-- Treesitter
require("config.nvim-treesitter")
require("config.nvim-treesitter-textobjects")

-- Terminal
require("config.toggleterm")

-- LSP / Completion
require("config.copilot")
require("config.cmake")

-- Debugging
require("config.dap")
require("config.dappy")

-- Git
require("neogit").setup({})

-- Misc
require("config.conform")
require("config.persisted")
require("config.obsidian")

-- Plugins with no separate config module
require("Comment").setup()
require("im_select").setup({})
require("aerial").setup({})
require("yazi").setup({
	open_for_directories = false,
	keymaps = {
		show_help = "<f1>",
	},
})
require("img-clip").setup({
	default = {
		embed_image_as_base64 = false,
		prompt_for_file_name = false,
		drag_and_drop = {
			insert_mode = true,
		},
		use_absolute_path = true,
	},
})

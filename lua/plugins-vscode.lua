-- Install Lazy.nvim automatically if it's not installed(Bootstraping)
-- Hint: string concatenation is done by `..`
local is_vscode = vim.g.vscode == true
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
	},
  -- may be useful
	-- Git integration
  {
    "tpope/vim-fugitive",
		cond = not is_vscode, -- have bug
  },
	{
		"keaising/im-select.nvim",
		cond = not is_vscode,
		config = function()
			require("im_select").setup({})
		end,
	},
	-- Improve the performance of big file
	{
		"LunarVim/bigfile.nvim",
		cond = not is_vscode,
	},
	{
		"stevearc/conform.nvim",
		opts = {},
		cond = not is_vscode,
		config = function()
			require("config.conform")
		end,
	},
})

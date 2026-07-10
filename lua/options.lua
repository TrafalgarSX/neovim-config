local options = {
	backup = false, -- creates a backup file
	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	completeopt = { "menu", "menuone", "noselect" }, -- mostly just for cmp
	mouse = "a", -- allow the mouse to be used in neovim

	cmdheight = 1, -- more space in the neovim command line for displaying messages
	conceallevel = 1, -- so that `` is visible in markdown files
	fileencoding = "utf-8", -- the encoding written to a file
	incsearch = true, -- search as characters are entered
	hlsearch = true, -- highlight all matches on previous search pattern
	ignorecase = true, -- ignore case in search patterns
	smartcase = true, -- but make it case sensitive if an uppercase is entered
	showmode = false, -- we don't need to see things like -- INSERT -- anymore
	showtabline = 2, -- always show tabs
	smartindent = true, -- make indenting smarter again
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	swapfile = false, -- creates a swapfile

	termguicolors = true, -- set term gui colors (most terminals support this)
	timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)
	undofile = true, -- enable persistent undo
	updatetime = 400, -- faster completion (4000ms default)
	sessionoptions = "curdir,folds,globals,help,tabpages,terminal,winsize", -- better session management
	foldlevel = 99, -- start with all folds open
	writebackup = true, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	cursorline = true, -- highlight the current line
	number = true, -- set numbered lines
	relativenumber = true, -- set relative numbered lines
	numberwidth = 4, -- set number column width to 2 {default 4}

	tabstop = 2, -- insert 2 spaces for a tab
	softtabstop = 2,
	shiftwidth = 2, -- the number of spaces inserted for each indentation
	expandtab = true,

	signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
	wrap = true, -- display lines as one long line
	linebreak = true, -- companion to wrap, don't split words
	scrolloff = 10, -- minimal number of screen lines to keep above and below the cursor
	sidescrolloff = 10, -- minimal number of screen columns either side of cursor if wrap is `false`
	guifont = "Hack Nerd Font Mono:h11", -- the font used in graphical neovim applications
	whichwrap = "bs<>[]", -- which "horizontal" keys are allowed to travel to prev/next line
	background = "dark",
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.opt.iskeyword:append("-") -- 连字符连接的单词会被视为一个单词
-- Disable built-in ftplugin mappings to avoid conflicts with nvim-treesitter-textobjects
vim.g.no_plugin_maps = true
-- 禁用自动注释
vim.api.nvim_create_autocmd("BufEnter", {
	desc = "Rid auto comment for new string",
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- For nvim-surround
-- 参见 `:h nvim-surround.options`
vim.g.nvim_surround_no_mappings = true

-- For nvim-tree
-- disable netrw at the very start of your init.lua (strongly advised)
if not vim.g.vscode then
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1
end

-- 禁用不必要的 provider 来提升启动速度
vim.g.loaded_node_provider = 0 -- 如果启用不知道为什么 checkhealth 会在这里卡死
vim.g.loaded_ruby_provider = 0 -- 绝大多数人都用不到
vim.g.loaded_perl_provider = 0 -- 绝大多数人都用不到
-- 平台相关设置
if vim.fn.has("win32") == 1 then
	vim.o.shell = "nu"
	vim.o.shellcmdflag = "--no-config-file -c" -- 改成 nu 的参数
	-- 不确定是否正确，先这样设置，后续再调整
	vim.o.shellredir = "o+e> %s"
	vim.o.shellpipe =
		"| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record"
	vim.o.shellxquote = ""
	vim.o.shellquote = ""
	vim.o.shellxescape = ""
	vim.g.python3_host_prog = "C:/Users/guoya/scoop/apps/python/current/python.exe"
elseif vim.fn.has("unix") == 1 then
	vim.g.python3_host_prog = "/usr/bin/python3"
end

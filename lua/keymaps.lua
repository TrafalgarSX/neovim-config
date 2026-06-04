local opts = { noremap = true, silent = true }
-- local false_opts = { noremap = true, silent = true }
-- local term_opts = { silent = true }
-- local keydel = vim.keymap.del
--
-- Shorten function name
local keymap = vim.keymap.set

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Hint: see `:h vim.map.set()`
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
-- delta: 2 lines
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", ":m .+1<CR>==", opts)
keymap("n", "<A-k>", ":m .-2<CR>==", opts)

keymap("n", "<leader>qa", ":qa<CR>", opts)

-----------------
-- Visual mode --
-----------------
-- Stay in indent mode
keymap("v", "<", "<gv^", opts)
keymap("v", ">", ">gv^", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":m '>+1<CR>gv=gv", opts)
keymap("x", "K", ":m '<-2<CR>gv=gv", opts)
keymap("x", "<A-j>", ":m '>+1<CR>gv=gv", opts)

-----------------
-- Insert mode --
-----------------
keymap("i", "<C-;>", "<End>", opts)

if vim.g.vscode then
	-- call vscode commands from neovim
	-- general keymaps
	keymap(
		{ "n", "i" },
		"<C-`>",
		"<cmd>lua require('vscode').action('workbench.action.terminal.toggleTerminal')<CR>",
		opts
	)
	-- 格式化当前文件
	keymap({ "n", "v" }, "<leader>fd", "<cmd>lua require('vscode').action('editor.action.formatDocument')<CR>", opts)
	-- 打开 VSCode 的右侧的文件浏览
	keymap({ "n", "v" }, "<leader>e", "<cmd>lua require('vscode').action('workbench.view.explorer')<CR>", opts)
	-- 快速搜索文件，VSCode 中是 Ctrl+p
	keymap({ "n", "v" }, "<leader>ff", "<cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>", opts)
	-- VSCode 中的 ctrl+shiflt+p 功能，打开 VSCode 的功能面板
	keymap({ "n", "v" }, "<leader>cp", "<cmd>lua require('vscode').action('workbench.action.showCommands')<CR>", opts)
	-- 打开 VSCode 的搜索框
	keymap({ "n", "v" }, "<leader>rg", "<cmd>lua require('vscode').action('workbench.action.findInFiles')<CR>", opts)
	-- pin 当前打开的文件
	keymap({ "n", "v" }, "<leader>pi", "<cmd>lua require('vscode').action('workbench.action.pinEditor')<CR>", opts)
	-- unpin 当前打开的文件
	keymap({ "n", "v" }, "<leader>up", "<cmd>lua require('vscode').action('workbench.action.unpinEditor')<CR>", opts)
	-- 使用 explorer 打开当前文件所在目录
	keymap({ "n", "v" }, "<leader>fe", "<cmd>lua require('vscode').action('revealFileInOS')<CR>", opts)
	-- 隐藏或显示 sidebar，即转换 sidebar 的可见性
	keymap(
		{ "n", "v" },
		"<leader>hs",
		"<cmd>lua require('vscode').action('workbench.action.toggleSidebarVisibility')<CR>"
	)
	-- 在搜索框里搜索当前光标下的词（word）
	keymap(
		{ "n", "v" },
		"<leader>fw",
		"<cmd>lua require('vscode').action('workbench.action.findInFiles', {args = { query = vim.fn.expand('<cword>') }})<CR>"
	)
	-- 切换当前代码行的断点
	keymap(
		{ "n", "v" },
		"<leader>b",
		"<cmd>lua require('vscode').action('editor.debug.action.toggleBreakpoint')<CR>",
		opts
	)
	-- 显示快速修复列表
	keymap({ "n", "v" }, "<leader>a", "<cmd>lua require('vscode').action('editor.action.quickFix')<CR>", opts)
	keymap({ "n", "v" }, "<leader>cn", "<cmd>lua require('vscode').action('notifications.clearAll')<CR>", opts)
	keymap({ "n", "v" }, "<leader>sp", "<cmd>lua require('vscode').action('workbench.actions.view.problems')<CR>", opts)
	keymap({ "n", "v" }, "<leader>cr", "<cmd>lua require('vscode').action('code-runner.run')<CR>", opts)
	-- project manager keymap
	keymap({ "n", "v" }, "<leader>ps", "<cmd>lua require('vscode').action('projectManager.saveProject')<CR>", opts)
	keymap(
		{ "n", "v" },
		"<leader>pa",
		"<cmd>lua require('vscode').action('projectManager.listProjectsNewWindow')<CR>",
		opts
	)
	keymap({ "n", "v" }, "<leader>pe", "<cmd>lua require('vscode').action('projectManager.editProjects')<CR>", opts)
else
	-- For nvim-tree.lua
	-- default leader key: \
	keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
	keymap("n", "<leader>bd", ":lua Snacks.bufdelete()<CR>", opts)

	-- For nvim-treesitter
	-- 1. Press `gss` to intialize selection. (ss = start selection)
	-- 2. Now we are in the visual mode.
	-- 3. Press `gsi` to increment selection by AST node. (si = selection incremental)
	-- 4. Press `gsc` to increment selection by scope. (sc = scope)
	-- 5. Press `gsd` to decrement selection. (sd = selection decrement)

	-- nvim-dap
	keymap("n", "<F9>", ":lua require'dap'.toggle_breakpoint()<CR>", opts)
	keymap("n", "<F5>", ":lua require'dap'.continue()<CR>", opts)
	keymap("n", "<F10>", ":lua require'dap'.step_over()<CR>", opts)
	keymap("n", "<F11>", ":lua require'dap'.step_into()<CR>", opts)
	keymap("n", "<F12>", ":lua require'dap'.step_out()<CR>", opts)

	-- for lsp
	keymap("n", "<space>ie", ":lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>", opts)

	-- for yazi.nvim
	keymap("n", "<space>-", ":Yazi<CR>", opts)
	keymap("n", "<space>cw", ":Yazi cwd<CR>", opts)
	keymap("n", "<C-up>", ":Yazi toggle<CR>", opts)

	-- for Snacks.terminal
	keymap({ "n", "i" }, "<C-`>", ":lua Snacks.terminal.toggle()<CR>", opts)

	-- for test
end

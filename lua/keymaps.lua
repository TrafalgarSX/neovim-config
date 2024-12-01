local opts = { noremap = true, silent = true }
-- local false_opts = { noremap = true, silent = true }
-- local term_opts = { silent = true }
-- local keydel = vim.keymap.del
--
-- Shorten function name
local is_vscode = vim.g.vscode == true
local keymap = vim.keymap.set

--[[
--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
]]

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

-- for hop 
keymap("n", "<space>w", ":HopWordAC<CR>", opts)
keymap("n", "<space>b", ":HopWordBC<CR>", opts)
--[[ 
keymap("n", "<space>p", ":HopPattern<CR>", opts)
keymap("n", "s", ":HopChar2<CR>", opts)
keymap("n", "t", ":HopLineStart<CR>", opts)
keymap("n", "f", ":HopPatternCurrentLineAC<CR>", opts)
keymap("n", "F", ":HopPatternCurrentLineBC<CR>", opts)
 ]]


if not is_vscode then
  -- For nvim-tree.lua
  -- default leader key: \
  keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

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
  keymap("n", "<space>i", ":lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>", opts)

end


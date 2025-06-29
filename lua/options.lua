local options = {
  backup = false,                                  -- creates a backup file
  clipboard = "unnamedplus",                       -- allows neovim to access the system clipboard
  completeopt = { "menu", "menuone", "noselect" }, -- mostly just for cmp
  mouse = "a",                                     -- allow the mouse to be used in neovim

  --	cmdheight = 2, -- more space in the neovim command line for displaying messages
  conceallevel = 1,       -- so that `` is visible in markdown files
  fileencoding = "utf-8", -- the encoding written to a file
  incsearch = true,       -- search as characters are entered
  hlsearch = true,        -- highlight all matches on previous search pattern
  ignorecase = true,      -- ignore case in search patterns
  smartcase = true,       -- but make it case sensitive if an uppercase is entered	pumheight = 10, -- pop up menu height
  showmode = false,       -- we don't need to see things like -- INSERT -- anymore
  showtabline = 2,        -- always show tabs
  smartindent = true,     -- make indenting smarter again
  splitbelow = true,      -- force all horizontal splits to go below current window
  splitright = true,      -- force all vertical splits to go to the right of current window
  swapfile = false,       -- creates a swapfile

  termguicolors = true,   -- set term gui colors (most terminals support this)
  timeoutlen = 300,       -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = false,       -- enable persistent undo
  updatetime = 400,       -- faster completion (4000ms default)
  writebackup = true,     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  cursorline = true,      -- highlight the current line
  number = true,          -- set numbered lines
  relativenumber = false, -- set relative numbered lines
  numberwidth = 4,        -- set number column width to 2 {default 4}

  tabstop = 2,            -- insert 2 spaces for a tab
  softtabstop = 2,
  shiftwidth = 2,         -- the number of spaces inserted for each indentation
  expandtab = true,

  signcolumn = "yes",                  -- always show the sign column, otherwise it would shift the text each time
  wrap = true,                         -- display lines as one long line
  linebreak = true,                    -- companion to wrap, don't split words
  scrolloff = 8,                       -- minimal number of screen lines to keep above and below the cursor
  sidescrolloff = 8,                   -- minimal number of screen columns either side of cursor if wrap is `false`
  guifont = "Hack Nerd Font Mono:h11", -- the font used in graphical neovim applications
  whichwrap = "bs<>[]",                -- which "horizontal" keys are allowed to travel to prev/next line
  background = "dark",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.iskeyword:append("-") -- 连字符连接的单词会被视为一个单词
-- 禁用自动注释
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Rid auto comment for new string",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- For nvim-tree
-- disable netrw at the very start of your init.lua (strongly advised)
if not vim.g.vscode then
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

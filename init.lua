require('options')

require('keymaps')

if vim.g.vscode then
  require('plugins-vscode')
else
  require('plugins')

  require('colorscheme')

  require('lsp')

  require('aftercare')
end




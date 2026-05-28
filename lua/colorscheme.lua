-- Gruvbox-material config must be set before colorscheme
vim.g.gruvbox_material_background = "medium"
vim.g.gruvbox_material_foreground = "mix"
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_dim_inactive_windows = 1
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_current_word = "high contrast background"

local colorscheme = "gruvbox-material"

local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not is_ok then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
end

local is_ok, nt = pcall(require, "nvim-treesitter")
if not is_ok then
	return
end

local parsers = {
	"c",
	"cpp",
	"cmake",
	"javascript",
	"lua",
	"vim",
	"yaml",
	"toml",
	"rust",
	"python",
	"json",
	"markdown",
	"markdown_inline",
	"zsh",
	"powershell",
	"nu",
}

local filetypes = {
	"c",
	"cpp",
	"cmake",
	"javascript",
	"lua",
	"vim",
	"yaml",
	"toml",
	"rust",
	"python",
	"json",
	"markdown",
	"zsh",
	"ps1",
	"nu",
}

nt.setup({
	ensure_installed = parsers,
})

-- Deferred: install missing parsers on demand instead of blocking startup
vim.api.nvim_create_user_command("TSInstallAll", function()
	for _, p in ipairs(parsers) do
		pcall(vim.cmd, "TSInstall " .. p)
	end
end, { desc = "Install all configured treesitter parsers" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = filetypes,
	callback = function()
		-- folds, provided by Neovim
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo.foldmethod = "expr"
		-- indentation, provided by nvim-treesitter
		-- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

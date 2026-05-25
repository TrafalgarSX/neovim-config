local is_ok, nt = pcall(require, "nvim-treesitter")
if not is_ok then
	return
end

nt.setup({
	ensure_installed = { "c", "cpp", "cmake", "javascript", "lua", "vim", "yaml", "toml", "rust", "python", "json",
		"markdown", "markdown_inline" },
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua", "c", "cpp", "h", "hpp", "cc", "cmake", "javascript", "yaml", "toml", "rust", "python", "json",
		"markdown", "markdown_inline" },
	callback = function()
		-- folds, provided by Neovim
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo.foldmethod = "expr"
		-- indentation, provided by nvim-treesitter
		-- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

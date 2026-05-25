local is_ok, toggleterm = pcall(require, "toggleterm")
if not is_ok then
	return
end

-- 判断系统

local shell
if vim.fn.has("win32") == 1 then
	shell = "pwsh.exe"
else
	shell = vim.o.shell
end


toggleterm.setup({
	size = 10,
	open_mapping = [[<C-`>]], -- how to open a new terminal
	hide_numbers = true,     -- hide the number column in toggleterm buffers
	close_on_exit = true,    -- close the terminal window when the process exits
	shell = shell,           -- change the default shell
	direction = "horizontal",
	float_opts = {
		-- The border key is *almost* the same as 'nvim_open_win'
		-- see :h nvim_open_win for details on borders however
		-- the 'curved' border is a custom border type
		-- not natively supported but implemented in this plugin.
		border = "curved",
		winblend = 0,
	},
})

-- Define key mappings for terminal mode
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "term://*toggleterm#*",
	callback = function()
		local opts = { noremap = true, buffer = 0 }
		-- Go back to the Normal model in terminal
		vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
		vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)

		vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
		vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
		vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
		vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)

		vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
	end,
})

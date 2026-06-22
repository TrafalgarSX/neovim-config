local is_ok, telescope = pcall(require, "telescope")
if not is_ok then
	return
end

-- Load extensions
pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "persisted")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.git_files, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {}) -- i.e. previously open files
vim.keymap.set("n", "<leader>fc", builtin.command_history, {}) -- i.e. previously open files
vim.keymap.set("n", "<leader>ac", builtin.commands, {}) -- i.e. previously open files
vim.keymap.set("n", "<leader>co", builtin.colorscheme, {}) -- i.e. previously open files
vim.keymap.set("n", "<leader>fd", builtin.fd, {}) -- i.e. previously open files
vim.keymap.set("n", "<leader>fk", builtin.keymaps, {}) -- i.e. previously open files
vim.keymap.set("n", "<leader>fm", builtin.marks, {}) -- i.e. previously open files
vim.keymap.set("n", "<leader>rg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fr", function() -- fc = find by command
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

vim.keymap.set(
	"n",
	"<leader>fw",
	require("telescope.builtin").grep_string,
	{ desc = "Telescope grep string under cursor" }
)
--[[
vim.keymap.set("n", "<leader>fw", function()
	builtin.grep_string({
    -- 这里可以使用更严格的正则表达式实现搜索 search = '\\C\\<' .. vim.fn.expand('<cword>') .. '\\>',
    search = vim.fn.expand("<cword>"),
		word_match = "-w", -- 只匹配完整单词
		trim_text = true,
	})
end, { desc = "[F]ind [W]ord under cursor (exact match)" })
]]

-- Telescope extensions
vim.keymap.set("n", "<leader>pe", ":Telescope persisted<CR>", {})

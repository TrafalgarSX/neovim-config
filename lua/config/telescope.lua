local is_ok, builtin = pcall(require, "telescope.builtin")
if not is_ok then
	return
end

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
vim.keymap.set("n", "<leader>fr", function() -- fc = find by command
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

-- Telescope projects
vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>", {})

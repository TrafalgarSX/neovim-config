local is_ok, obsidian = pcall(require, "obsidian")
if not is_ok then
	return
end

local obsidian_path
if vim.fn.has("win32") == 1 then
	obsidian_path = "C:/workspace/obsidian/ProgramKnowledge"
else
	obsidian_path = "/home/trafalgar/misc/obsidian/"
end

obsidian.setup({
	legacy_commands = false, -- this will be removed in 4.0.0
	workspaces = {
		{
			name = "ProgramKnowledge",
			path = obsidian_path,
		},
	},
})

local is_ok, obsidian = pcall(require, "obsidian")
if not is_ok then
  return
end

obsidian.setup({
  workspaces = {
    {
      name = "ProgramKnowledge",
      path = "C:/workspace/obsidian/ProgramKnowledge",
    },
  },
})

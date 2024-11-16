local is_ok, copilot = pcall(require, "copilot")
if not is_ok then
	return
end

copilot.setup()
--[[
copilot.setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})
--]]

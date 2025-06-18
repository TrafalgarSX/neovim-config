local is_ok, copilot = pcall(require, "copilot")
if not is_ok then
  return
end

require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    hide_during_completion = false,
    keymap = {
      accept = '<Tab>',
    },
  },
  panel = { enabled = false },
})

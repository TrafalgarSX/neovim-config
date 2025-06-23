local is_ok, bufferline = pcall(require, "bufferline")
if not is_ok then
  return
end

bufferline.setup {
  options = {
    mode = "buffers", -- set to "tabs" to only show tabpages instead
    separator_style = 'slant',
    show_close_icon = false,
    show_buffer_close_icons = false,
    always_show_bufferline = true,
    style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
    numbers = "none",                               -- can be "none", "ordinal", "buffer_id" or "both"
    close_command = "bdelete! %d",                  -- can be a string | function, | false see "Mouse actions"
    right_mouse_command = "bdelete! %d",            -- can be a string | function | false, see "Mouse actions"
    left_mouse_command = "buffer %d",               -- can be a string | function, | false see "Mouse actions"
    middle_mouse_command = nil,                     -- can be a string | function, | false see "Mouse actions"
    buffer_close_icon = '󰅖',
    modified_icon = '● ',
    close_icon = ' ',
    left_trunc_marker = ' ',
    right_trunc_marker = ' ',
    diagnostics = false,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "left",
        separator = true,
      }
    },
  }
}

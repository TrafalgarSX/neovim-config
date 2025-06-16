local is_ok, bufferline = pcall(require, "bufferline")
if not is_ok then
	return
end

bufferline.setup {}

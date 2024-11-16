local is_ok, dappy = pcall(require, "dap-python")
if not is_ok then
	return
end

dappy.setup("python3")

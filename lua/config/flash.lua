local is_ok, flash = pcall(require, "flash")
if not is_ok then
	return
end

-- just use default
flash.setup()

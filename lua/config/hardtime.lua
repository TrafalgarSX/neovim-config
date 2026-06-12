local is_ok, hardtime = pcall(require, "hardtime")
if not is_ok then
	return
end


hardtime.setup({
    disabled_keys = {
       ["<Up>"] = false, -- Allow <Up> key
       ["<Down>"] = false,
       ["<Left>"] = false,
       ["<Right>"] = false,
    },
    disable_mouse = false ,
    max_count = 5,
})
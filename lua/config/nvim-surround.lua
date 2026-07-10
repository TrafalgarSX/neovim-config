local is_ok, nvim_surround = pcall(require, "nvim-surround")
if not is_ok then
	return
end

nvim_surround.setup({})

-- 参见 `:h nvim-surround.keymaps`
vim.keymap.set("n", "yv", "<Plug>(nvim-surround-normal)", {
	desc = "围绕 motion 添加包围对（普通模式）",
})
vim.keymap.set("n", "yvv", "<Plug>(nvim-surround-normal-cur)", {
	desc = "围绕当前行添加包围对（普通模式）",
})

vim.keymap.set("n", "dv", "<Plug>(nvim-surround-delete)", {
	desc = "删除包围对",
})
vim.keymap.set("n", "cv", "<Plug>(nvim-surround-change)", {
	desc = "修改包围对",
})

vim.keymap.set("x", "SS", "<Plug>(nvim-surround-visual)", {
	desc = "围绕可视选择区域添加包围对",
})
vim.keymap.set("x", "gS", "<Plug>(nvim-surround-visual-line)", {
	desc = "围绕可视选择区域添加包围对，放在新行上",
})
--[[
vim.keymap.set("i", "<C-g>s", "<Plug>(nvim-surround-insert)", {
	desc = "在光标周围添加包围对（插入模式）",
})
vim.keymap.set("i", "<C-g>S", "<Plug>(nvim-surround-insert-line)", {
	desc = "在光标周围添加包围对，放在新行上（插入模式）",
})
vim.keymap.set("n", "yV", "<Plug>(nvim-surround-normal-line)", {
	desc = "围绕 motion 添加包围对，放在新行上（普通模式）",
})
vim.keymap.set("n", "yVV", "<Plug>(nvim-surround-normal-cur-line)", {
	desc = "围绕当前行添加包围对，放在新行上（普通模式）",
})
vim.keymap.set("n", "cV", "<Plug>(nvim-surround-change-line)", {
	desc = "修改包围对，将替换内容放在新行上",
})
--]]

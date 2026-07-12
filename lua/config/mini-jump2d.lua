local is_ok, jump2d = pcall(require, "mini.jump2d")
if not is_ok then
	return
end

jump2d.setup({

	-- 视觉效果选项
	view = {
		-- 是否调暗包含至少一个跳转点的行
		dim = true,

		-- 显示未来多少步。设置为较大数字以显示所有步骤。
		n_steps_ahead = 1,
	},
	mappings = {
		-- start_jumping = "<CR>",
		start_jumping = "",
	},
})

vim.keymap.set(
	"n",
	"<leader><leader>w",
	"<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.word_start)<CR>",
	{ desc = "Jump to word start" }
)

vim.keymap.set(
	"n",
	"<leader>sw",
	"<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.query)<CR>",
	{ desc = "Jump to query taken from user input" }
)

return {
	explorer = { enabled = true },
	indent = { enabled = true },
	input = { enabled = true },
	picker = { enabled = true },
	notifier = { enabled = true, timeout = 3000 },
	quickfile = { enabled = true },
	scope = { enabled = true },
	scroll = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	-- 4. 样式配置：让通知看起来更现代
	styles = {
		notification = {
			wo = { wrap = true }, -- 通知文字过长时自动换行
		},
	},
}

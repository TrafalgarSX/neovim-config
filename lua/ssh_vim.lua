if vim.env.SSH_CONNECTION then
	-- 1. 定义一个全局变量，用来记录当前输入法同步是开启还是关闭
	_G.ime_sync_enabled = true -- 默认关闭
else
	-- 这是本地终端
	_G.ime_sync_enabled = false -- 默认关闭
end

-- 2. 定义一个函数：专门用来“开启”自动命令
local function enable_ime_sync()
	-- 创建或清空名为 "WeztermImeSync" 的组
	local ime_sync_group = vim.api.nvim_create_augroup("WeztermImeSync", { clear = true })

	-- 定义向 WezTerm 发送信号的函数
	local function send_to_wezterm(mode_value)
		-- 1. 使用 Neovim 内置 API 将模式值（Normal 或 Insert）进行 Base64 编码
		local b64_value = vim.base64.encode(mode_value)

		-- vim.notify(b64_value, vim.log.levels.WARN, { title = "Nvim-config" })
		-- 2. 构造 WezTerm 官方标准的 1337 协议字符串
		-- \x1b]1337;SetUserVar=变量名=Base64后的值\x07
		local osc_sequence = string.format("\x1b]1337;SetUserVar=VimMode=%s\x07", b64_value)

		io.write(osc_sequence)
		io.flush()
	end

	-- 重新注册那两个 autocmd
	vim.api.nvim_create_autocmd("InsertLeave", {
		group = ime_sync_group,
		pattern = "*",
		callback = function()
			send_to_wezterm("Normal")
		end,
	})

	vim.api.nvim_create_autocmd("InsertEnter", {
		group = ime_sync_group,
		pattern = "*",
		callback = function()
			send_to_wezterm("Insert")
		end,
	})

	_G.ime_sync_enabled = true
	vim.notify("🚀 输入法同步已【开启】", vim.log.levels.INFO, { style = "fancy", title = "WezTerm IME" })
end

-- 3. 定义一个函数：专门用来“关闭”自动命令
local function disable_ime_sync()
	-- 核心：直接清空这个组，里面的所有 autocmd 会瞬间失效
	vim.api.nvim_create_augroup("WeztermImeSync", { clear = true })
	_G.ime_sync_enabled = false
	vim.notify("🛑 输入法同步已【关闭】", vim.log.levels.WARN, { style = "fancy", title = "WezTerm IME" })
end

-- 4. 定义 Toggle 切换函数
local function toggle_ime_sync()
	if _G.ime_sync_enabled then
		disable_ime_sync()
	else
		enable_ime_sync()
	end
end

-- 5. 绑定快捷键 (这里以 Leader 键 + i 为例，你可以换成任意你喜欢的快捷键)
-- 例如如果你没有设 Leader，默认是 \ 键，那快捷键就是 \i
vim.keymap.set("n", "<Leader><Leader>i", toggle_ime_sync, { desc = "Toggle IME Sync autocmd" })

local is_ok, persisted = pcall(require, "persisted")

if not is_ok then
	return
end

persisted.setup({
	should_save = function()
		-- Ref: https://github.com/folke/persistence.nvim/blob/166a79a55bfa7a4db3e26fc031b4d92af71d0b51/lua/persistence/init.lua#L46
		local bufs = vim.tbl_filter(function(b)
			if vim.bo[b].buftype ~= "" or vim.tbl_contains({ "gitcommit", "gitrebase", "jj" }, vim.bo[b].filetype) then
				return false
			end
			return vim.api.nvim_buf_get_name(b) ~= ""
		end, vim.api.nvim_list_bufs())

		if #bufs < 1 then
			return false
		end

		return true
	end,
})

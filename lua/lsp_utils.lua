local M = {}

M.get_default_capabilities = function()
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	return capabilities
end

return M

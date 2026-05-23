-- 参考自：https://github.com/Jaehaks/nvim_config/blob/main/lua/jaehak/core/lsp.lua
-- main purpose is fast linting diagnostics
local root_dir_python = function(bufnr, cb)
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	if string.match(bufname, "site%-packages") or string.match(bufname, "[\\/][Ll]ib[\\/]") then
		return
	end
	local root = vim.fs.root(bufnr, {
		"pyproject.toml",
		"pyrightconfig.json",
		"ruff.toml",
		".ruff.toml",
		"pyrefly.toml",
		".git",
	}) or vim.fn.expand("%:p:h")
	cb(root)
end

-- #############################################################
-- ####### basedpyright
-- #############################################################
-- main purpose is exact type checking diagnostics
-- It has very slow lsp completion to use
vim.lsp.config("basedpyright", {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_dir = root_dir_python,
	on_attach = function(client, _)
		-- formatting to ruff
		client.server_capabilities.documentFormattingProvider = false -- use ruff
		client.server_capabilities.documentRangeFormattingProvider = false -- use ruff
	end,
	settings = { -- see https://docs.basedpyright.com/latest/configuration/language-server-settings/
		basedpyright = {
			disableOrganizeImports = true, -- use ruff instead of it
			analysis = {
				autoImportCompletions = true,
				autoSearchPaths = true, -- auto serach command paths like 'src'
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
				diagnosticSeverityOverrides = {
					reportUnknownMemberType = "none", -- ignore warning : cannot infer member type of object like matplot
					reportUnusedCallResult = "none", -- ignore warning : If we don't use result of function, it must add '_ = '  in front of statement
				},
				exclude = {
					"**/.venv",
					"**/venv",
					"**/__pycache__",
					"**/dist",
					"**/build",
				},
			},
		},
	},
})

vim.lsp.config("ruff", {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_dir = root_dir_python,
	on_attach = function(client, _)
		-- lsp use ruff to formatter
		client.server_capabilities.documentFormattingProvider = false -- enable vim.lsp.buf.format()
		client.server_capabilities.documentRangeFormattingProvider = false -- formatting will be used by confirm.nvim
		client.server_capabilities.hoverProvider = false -- use basedpyrigt
	end,
	init_options = {
		settings = {
			logLevel = "warn",
			organizeImports = true, -- use code action for organizeImports
			showSyntaxErrors = true, -- show syntax error diagnostics
			codeAction = {
				disableRuleComment = { enable = false }, -- show code action about rule disabling
				fixViolation = { enable = false }, -- show code action for autofix violation
			},
			format = { -- use conform.nvim
				preview = false,
			},
			lint = { -- it links with ruff, but lint.args are different with ruff configuration
				enable = true,
			},
		},
	},
	single_file_support = false,
})

-- #############################################################
-- ####### clangd config
-- #############################################################
local root_dir_clangd = function(bufnr, cb)
	local root = vim.fs.root(bufnr, {
		".clangd",
		".clang-tidy",
		".clang-format",
		".compile_commands.json",
		".compile_flags.txt",
		".configure.ac",
		".git",
	}) or vim.fn.expand("%:p:h")
	cb(root)
end
---@class ClangdInitializeResult: lsp.InitializeResult
---@field offsetEncoding? string

---@type vim.lsp.Config
vim.lsp.config("clangd", {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "cuda" },
	root_dir = root_dir_clangd,
	capabilities = {
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
		offsetEncoding = { "utf-8", "utf-16" },
	},
	---@param init_result ClangdInitializeResult
	on_init = function(client, init_result)
		if init_result.offsetEncoding then
			client.offset_encoding = init_result.offsetEncoding
		end
	end,
})

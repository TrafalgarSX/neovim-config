-- Note: The order matters: require("mason") -> require("mason-lspconfig") -> require("lspconfig")

require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("mason-lspconfig").setup({
	-- A list of servers to automatically install if they're not already installed.
	ensure_installed = {"ruff", "basedpyright", "lua_ls", "bashls", "clangd", "ts_ls" },
})

-- Set different settings for different languages' LSP.
-- LSP list: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- How to use setup({}): https://github.com/neovim/nvim-lspconfig/wiki/Understanding-setup-%7B%7D
--     - the settings table is sent to the LSP.
--     - on_attach: a lua callback function to run after LSP attaches to a given buffer.
local lspconfig = require("lspconfig")

-- Customized on_attach function.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions.
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)


local inlay_hint_servers = { "clangd", "basedpyright", "ts_ls" } -- 添加支持 inlay_hint 的语言服务器名称
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer.
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	if vim.tbl_contains(inlay_hint_servers, client.name) then
		-- WARNING: This feature requires Neovim 0.10 or later.
		vim.lsp.inlay_hint.enable()
	end

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<space>cd", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>dd", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<space>f", function()
		vim.lsp.buf.format({
			async = true,
			-- Predicate used to filter clients. Receives a client as
			-- argument and must return a boolean. Clients matching the
			-- predicate are included.
			filter = function(client)
				-- NOTE: If an LSP contains a formatter, we don't need to use null-ls at all.
				return client.name == "null-ls" or client.name == "hls"
			end,
		})
	end, bufopts)
end

-- How to add an LSP for a specific programming language?
-- 1. Use `:Mason` to install the corresponding LSP.
-- 2. Add the configuration below. The syntax is `lspconfig.<name>.setup(...)`
-- Hint (find <name> here) : https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
--[[               
  autoSearchPaths = true,
  diagnosticMode = 'openFilesOnly',
  typeCheckingMode = 'off',
  useLibraryCodeForTypes = true 
]]
-- ref: https://github.com/astral-sh/ruff-lsp/issues/384
-- ref: https://github.com/petobens/dotfiles/blob/55cce522f213144884a2d70b80de8f531aae1958/nvim/lua/plugin-config/lsp_config.lua#L112
lspconfig.basedpyright.setup({
  -- on_attach = on_attach,
  settings = {
      basedpyright = {
          disableOrganizeImports = true, --using ruff
          analysis = {
            ignore = { '*' }, -- Using ruff
            typeCheckingMode = 'off',
          },
      },
  },
})

lspconfig.ruff.setup({
  on_attach = on_attach,
  init_options = {
        settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = {},
        }
  }
})


lspconfig.lua_ls.setup({
	on_attach = on_attach,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim).
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global.
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files.
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier.
			telemetry = {
				enable = false,
			},
		},
	},
})

-- All of the LSP servers I use that don't need anything but factory config.
local lsp_servers_with_default_config = {
	"bashls",
	"ts_ls",
	"clangd",
	"cmake",
}

for _, lsp in ipairs(lsp_servers_with_default_config) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
	})
end

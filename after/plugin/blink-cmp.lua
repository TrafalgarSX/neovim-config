if vim.g.vscode then
	return
end

local is_ok, cmp = pcall(require, "blink.cmp")
if not is_ok then
	return
end

cmp.setup({
	-- Tab to select next candidate，Enter to accept
	keymap = {
		preset = "default",
		["<Tab>"] = { "show_and_insert_or_accept_single", "select_next" },
		["<S-Tab>"] = { "show_and_insert_or_accept_single", "select_prev" },
        ["<CR>"] = { "accept", "fallback" },
		-- Scroll docs with C-b / C-f
		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },
		-- Close completion window, stay in insert mode
		["<C-e>"] = { "cancel", "fallback" },
		-- Manually trigger completion
		["<C-Space>"] = { "show", "fallback" },

	},

	-- Appearance: nvim-cmp style menu layout
	completion = {
		documentation = { auto_show = false },
		menu = {
			draw = {
				columns = {
					{ "label", "label_description", gap = 1 },
					{ "kind_icon", "kind" },
				},
			},
		},
	},

	-- Signature help (experimental, opt-in)
	signature = { enabled = true },

	-- Sources
	sources = {
		default = { "lsp", "path", "snippets", "buffer", "avante" },
		providers = {
			avante = {
				name = "avante",
				module = "blink-cmp-avante",
				score_offset = 90,
				fallbacks = {},
				opts = {},
			},
			cmdline = {
				min_keyword_length = function(ctx)
					-- when typing a command, only show when the keyword is 3 characters or longer
					if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
						return 2
					end
					return 0
				end,
			},
		},
	},

	-- Fuzzy: prefer Rust implementation for best performance
	fuzzy = { implementation = "prefer_rust" },

	-- Snippets: use built-in vim.snippet with friendly-snippets
	snippets = { preset = "default" },

	-- Cmdline completion (/, ?, :)
	cmdline = {
		keymap = {
			["<Tab>"] = { "show_and_insert_or_accept_single", "select_next" },
			["<S-Tab>"] = { "show_and_insert_or_accept_single", "select_prev" },
			["<CR>"] = { "accept_and_enter", "fallback" },
			["<C-space>"] = { "show", "fallback" },

			["<C-n>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<Right>"] = { "select_next", "fallback" },
			["<Left>"] = { "select_prev", "fallback" },

			["<C-y>"] = { "select_and_accept", "fallback" },
			["<C-e>"] = { "cancel", "fallback" },
		},
		completion = {
			list = {
				selection = {
					preselect = false,
					auto_insert = true,
				},
			},
			menu = { auto_show = true },
		},
		sources = function()
			local type = vim.fn.getcmdtype()
			if type == "/" or type == "?" then
				return { "buffer" }
			end
			return { "cmdline", "path", "buffer" }
		end,
	},
})

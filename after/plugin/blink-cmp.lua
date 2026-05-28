if vim.g.vscode then return end

local is_ok, cmp = pcall(require, "blink.cmp")
if not is_ok then
	return
end

cmp.setup({
	-- Use super-tab for VSCode-like Tab-to-accept behavior
	keymap = {
		preset = "super-tab",
		-- Scroll docs with C-b / C-f
		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },
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
		},
	},

	-- Fuzzy: prefer Rust implementation for best performance
	fuzzy = { implementation = "prefer_rust" },

	-- Snippets: use built-in vim.snippet with friendly-snippets
	snippets = { preset = "default" },

	-- Cmdline completion (/, ?, :)
	cmdline = {
		keymap = { preset = "cmdline" },
		completion = { menu = { auto_show = true } },
		sources = function()
			local type = vim.fn.getcmdtype()
			if type == "/" or type == "?" then
				return { "buffer" }
			end
			return { "cmdline", "path", "buffer" }
		end,
	},
})

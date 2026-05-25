require("avante").setup({
	input = { provider = "dressing" },
	provider = "deepseek",
	providers = {
		deepseek = {
			__inherited_from = "openai",
			api_key_name = "DEEPSEEK_API_KEY",
			endpoint = "https://api.deepseek.com",
			model = "deepseek-v4-pro",
			extra_request_body = {
				max_tokens = 300000,
				thinking = { type = "enabled" },
			},
		},
	},
})

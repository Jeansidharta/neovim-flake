require("blink.cmp").setup({
	keymap = { preset = "super-tab" },

	trigger = {
		signature_help = {
			enabled = true,
		},
	},
	windows = {
		autocomplete = {
			border = "rounded",
		},
		documentation = {
			auto_show = true,
			border = "rounded",
		},
		signature_help = {
			border = "rounded",
		},
	},
	sources = {
		completion = {
			enabled_providers = { "lsp", "path", "snippets", "buffer", "luasnip" },
		},
		providers = {
			luasnip = {
				name = "luasnip",
				module = "blink-luasnip-src",

				score_offset = -3,
			},
		},
	},
})

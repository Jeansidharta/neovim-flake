require("blink.cmp").setup({
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
		providers = {
			{ "blink.cmp.sources.lsp", name = "Lsp", score_offset = 9999 },
			{ "blink.cmp.sources.path", name = "Path", score_offset = -3 },
			{ "blink-luasnip-src", name = "Luasnip", score_offset = -3 },
			{ "blink.cmp.sources.snippets", name = "Snippets", score_offset = -3 },
			{ "blink.cmp.sources.buffer", name = "Buffer", score_offset = 0 },
		},
	},
})

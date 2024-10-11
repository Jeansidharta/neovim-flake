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
			{
				{ "blink.cmp.sources.lsp" },
				{ "blink.cmp.sources.path" },
				{ "blink.cmp.sources.snippets", score_offset = -3 },
				{ "blink-luasnip-src" },
			},
			{ { "blink.cmp.sources.buffer" } },
		},
	},
})

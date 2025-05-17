require("blink.cmp").setup({
	keymap = { preset = "super-tab" },

	signature = {
		enabled = true,
		window = {
			border = "rounded",
		},
	},
	completion = {
		accept = {
			auto_brackets = {
				enabled = true,
			}
		},
		menu = {
			auto_show = true,
			border = "rounded",
		},
		documentation = {
			auto_show = true,
			window = {
				border = "rounded",
			},
		},
	},
	fuzzy = {
		prebuilt_binaries = {
			-- Required since this package is downloaded through nix
			download = false,
		},
	},
	snippets = {
		preset = "luasnip",
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
})

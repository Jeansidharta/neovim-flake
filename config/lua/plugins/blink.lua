require("blink.cmp").setup({
	keymap = { preset = "super-tab" },

	signature = {
		enabled = true,
		window = {
			border = "rounded",
		},
	},
	completion = {
		menu = {
			border = "rounded",
			draw = {
				-- We don't need label_description now because label and label_description are already
				-- conbined together in label by colorful-menu.nvim.
				columns = { { "kind_icon" }, { "label", gap = 1 } },
				components = {
					label = {
						text = function(ctx)
							return require("colorful-menu").blink_components_text(ctx)
						end,
						highlight = function(ctx)
							return require("colorful-menu").blink_components_highlight(ctx)
						end,
					},
				},
			},
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

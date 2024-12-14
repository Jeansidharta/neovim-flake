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
		},
		documentation = {
			auto_show = true,
			window = {
				border = "rounded",
			},
		},
	},
	snippets = {
		expand = function(snippet)
			require("luasnip").lsp_expand(snippet)
		end,
		active = function(filter)
			if filter and filter.direction then
				return require("luasnip").jumpable(filter.direction)
			end
			return require("luasnip").in_snippet()
		end,
		jump = function(direction)
			require("luasnip").jump(direction)
		end,
	},
	sources = {
		default = { "lsp", "path", "luasnip", "buffer", "luasnip" },
	},
})

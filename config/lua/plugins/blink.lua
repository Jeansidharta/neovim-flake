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
			},
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
		per_filetype = {
			text = { "thesaurus" },
			markdown = { inherit_defaults = false, "thesaurus" },
		},
		providers = {
			thesaurus = {
				module = "blink-cmp-words.thesaurus",
				opts = {
					score_offset = 0,
					definition_pointers = { "!", "&", "^", "=", "~", "@" },
					similarity_pointers = { "&", "^" },
					-- The depth of similar words to recurse when collecting synonyms. 1 is similar words,
					-- 2 is similar words of similar words, etc. Increasing this may slow results.
					similarity_depth = 2,
				},
			},
		},
	},
})

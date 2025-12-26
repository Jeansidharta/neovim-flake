require("blink.cmp").setup({
	keymap = {
		preset = "super-tab",
		["<C-space>"] = {
			"show",
			"show_documentation",
			function(cmp)
				local doc = require("blink.cmp.completion.windows.documentation")
				if doc and doc.win and doc.win.buf then
					vim.schedule(function()
						require("config.utils").open_editor_temp_window(
							vim.api.nvim_buf_get_lines(doc.win.buf, 0, -1, false),
							"markdown"
						)
					end)
					return true
				else
					return false
				end
			end,
			"fallback",
		},
	},

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
			markdown = { "thesaurus", inherit_defaults = false },
		},
		providers = {
			thesaurus = {
				module = "blink-cmp-words.thesaurus",
				opts = {
					score_offset = 0,
					definition_pointers = {
						"!",
						"&",
						"^",
						"=",
						"~",
						"@",
						"@i",
						"~i",
						"#m",
						"#s",
						"#p",
						"%m",
						"%s",
						"%p",
						"*",
						"$",
						">",
						"<",
						"\\\\",
					},
					similarity_pointers = { "&", "^" },
					-- The depth of similar words to recurse when collecting synonyms. 1 is similar words,
					-- 2 is similar words of similar words, etc. Increasing this may slow results.
					similarity_depth = 2,
				},
			},
		},
	},
})

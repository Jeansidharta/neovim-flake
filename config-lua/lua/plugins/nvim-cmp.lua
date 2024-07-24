vim.o.completeopt = "menu,menuone,noselect"

local cmp = require("cmp")
local compare = cmp.config.compare
cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = function()
			if cmp.visible() then
				-- cmp.mapping.confirm({ select = true })
				cmp.confirm({ select = true })
			else
				cmp.complete()
			end
		end,
		-- ["<Esc>"] = cmp.mapping.abort(),
		["<C-d>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
				cmp.select_next_item()
				cmp.select_next_item()
				cmp.select_next_item()
				cmp.select_next_item()
				cmp.select_next_item()
				cmp.select_next_item()
				cmp.select_next_item()
			else
				fallback()
			end
		end,
		["<C-u>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
				cmp.select_prev_item()
				cmp.select_prev_item()
				cmp.select_prev_item()
				cmp.select_prev_item()
				cmp.select_prev_item()
				cmp.select_prev_item()
				cmp.select_prev_item()
			else
				fallback()
			end
		end,
	}),
	sorting = {
		comparators = {
			compare.kind,
			compare.offset,
			compare.exact,
			-- compare.scopes,
			compare.score,
			compare.recently_used,
			compare.locality,
			-- compare.sort_text,
			compare.length,
			compare.order,
		},
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp", priority = 300 },
		{ name = "buffer",   priority = 200 },
		{ name = "luasnip",  priority = 100 },
	}),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

-- "hrsh7th/cmp-nvim-lsp",
-- "hrsh7th/cmp-buffer",
-- "hrsh7th/cmp-path",
-- "hrsh7th/cmp-cmdline",
-- "hrsh7th/cmp-nvim-lua",
-- "saadparwaiz1/cmp_luasnip",

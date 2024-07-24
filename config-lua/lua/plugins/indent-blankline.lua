local highlight_char = {
	{ "IndentBlanklineIndent1", { fg = "#151433" } },
	{ "IndentBlanklineIndent2", { fg = "#1f1e4d" } },
}

local highlight_scope = {
	{ "IndentBlanklineScope", { fg = "#ff00ee" } },
}

local hooks = require("ibl.hooks")
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	vim.tbl_map(function(item)
		vim.api.nvim_set_hl(0, item[1], item[2])
	end, highlight_char)

	vim.tbl_map(function(item)
		vim.api.nvim_set_hl(0, item[1], item[2])
	end, highlight_scope)
end)

require("ibl").setup({
	indent = {
		highlight = vim.tbl_map(function(h)
			return h[1]
		end, highlight_char),
		tab_char = "▏",
		char = {
			"▹",
		},
	},
	scope = {
		enabled = true,
		highlight = vim.tbl_map(function(h)
			return h[1]
		end, highlight_scope),
	},
})

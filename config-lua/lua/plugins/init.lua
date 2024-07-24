require("plugins.telescope")
require("plugins.smart-splits")
require("plugins.mini-completion")
require("plugins.lsp-config")
require("plugins.git-signs")
require("plugins.hover")
require("plugins.indent-blankline")
require("plugins.lualine")
require("plugins.luasnip")
require("plugins.null")
require("plugins.statuscol")
require("plugins.treesitter")
require("plugins.vim-illuminate")
require("plugins.neoclip")

-- Set colorscheme
vim.g.tokyodark_transparent_background = true
vim.cmd([[colorscheme tokyodark]])

require("deferred-clipboard").setup({})

require("various-textobjs").setup({
	useDefaultKeymaps = true,
})

-- Setup vim-notify
require("telescope").load_extension("notify")
require("notify").setup({ background_colour = "#000000" })
vim.notify = require("notify")

-- Lsp lines
require("lsp_lines").setup({})
vim.diagnostic.config({
	virtual_lines = false,
})

require("oil").setup({
	columns = {
		"icon",
		-- "permissions",
		"size",
		-- "mtime",
	},
	view_options = {
		show_hidden = true,
		is_always_hidden = function(name, bufnr)
			return name == ".."
		end,
	},
})

require("substitute").setup({})

require("bufjump").setup({
	forward = "<C-i>",
	backward = "<C-o>",
	backwardInBuffer = "<C-p>",
	forwardInBuffer = "<C-l>",
})

require("fidget").setup({})

require("dressing").setup({})

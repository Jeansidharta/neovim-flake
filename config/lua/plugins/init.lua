-- Plugins should be setup so that importing them would be enough to trigger their setup.
-- Therefore, no need to do anything else after importing them.
require("plugins.telescope")
require("plugins.blink")
require("plugins.lsp-config")
require("plugins.git-signs")
require("plugins.indent-blankline")
require("plugins.lualine")
require("plugins.luasnip")
require("plugins.null")
require("plugins.statuscol")
require("plugins.treesitter")
require("plugins.vim-illuminate")
require("plugins.neoclip")
require("plugins.mdeval")

-- Set colorscheme
require("silkcircuit").setup ({ transparent = true })
vim.cmd([[colorscheme silkcircuit]])

require("various-textobjs").setup({
	keymaps = { useDefaults = true },
})

-- Setup vim-notify
require("telescope").load_extension("notify")
require("notify").setup({ background_colour = "#000000" })
-- The schedule_wrap is due to https://github.com/rcarriga/nvim-notify/issues/205
vim.notify = vim.schedule_wrap(require("notify"))

require("snacks").setup({
	input = {},
	picker = {
		ui_select = true,
	},
})

require("fyler").setup({
	close_on_open = true,
	default_explorer = true,
	close_on_select = true,
	icon_provider = "nvim_web_devicons",
})

require("atone").setup({
	keymaps = {
		tree = {
			next_node = "<Down>",
			pre_node = "<Up>",
		},
	},
})

require("markview").setup({
	markdown = {
		code_blocks = {
			border_hl = "CursorLine",
			label_hl = "Cursor",
			default = {
				block_hl = "CursorLine",
				pad_hl = "CursorLine",
			},
		},
	},
})

require("substitute").setup({})

require("bufjump").setup()

require("fidget").setup({})

require("overseer").setup()

require("colorizer").setup({})

require("zk").setup({})
require("telescope").load_extension("zk")

require("outline").setup({})

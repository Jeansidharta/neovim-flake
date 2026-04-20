-- Plugins should be setup so that importing them would be enough to trigger their setup.
-- Therefore, no need to do anything else after importing them.
require("plugins.blink")
require("plugins.lsp-config")
require("plugins.git-signs")
require("plugins.indent-blankline")
require("plugins.lualine")
require("plugins.luasnip")
require("plugins.null")
-- require("plugins.treesitter")
require("plugins.vim-illuminate")
require("plugins.mdeval")
require("plugins.dap")

require("marks")

require("vim._core.ui2").enable({})

-- Set colorscheme
-- require("config.colorscheme").setup()
-- vim.cmd([[colorscheme industry]])

require("various-textobjs").setup({
	keymaps = { useDefaults = true },
})

-- Setup vim-notify
require("notify").setup({ background_colour = "#000000" })
-- The schedule_wrap is due to https://github.com/rcarriga/nvim-notify/issues/205
vim.notify = vim.schedule_wrap(require("notify"))

require("fzf-lua").setup({
	winopts = {
		fullscreen = true,
	},
	keymap = {
		fzf = {
			["ctrl-q"] = "select-all+accept",
		},
	},
})

require("snacks").setup({
	input = {},
	picker = {
		ui_select = true,
	},
})

require("fyler").setup({
	integrations = {
		icon_provider = "nvim_web_devicons",
	},
	views = {
		finder = {
			default_explorer = true,
			win = {
				kind = "float",
				win_opts = {
					number = true,
					relativenumber = true,
					signcolumn = "yes",
				},
			},
		},
	},
})

require("atone").setup({
	keymaps = {
		tree = {
			next_node = "<Down>",
			pre_node = "<Up>",
		},
	},
})

require("bufjump").setup()

require("fidget").setup({
	notification = {
		window = {
			-- Make window's background transparent
			winblend = 0,
			border = "rounded",
		},
	},
})

require("colorizer").setup({})

require("zk").setup({})

require("outline").setup({})

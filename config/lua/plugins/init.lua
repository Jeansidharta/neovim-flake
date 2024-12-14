-- Plugins should be setup so that importing them would be enough to trigger their setup.
-- Therefore, no need to do anything else after importing them.
require("plugins.telescope")
require("plugins.smart-splits")
require("plugins.blink")
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
require("plugins.snipe")

-- Set colorscheme
vim.g.tokyodark_transparent_background = true
vim.cmd([[colorscheme tokyodark]])

require("deferred-clipboard").setup({})

require("various-textobjs").setup({
	keymaps = { useDefaults = true },
})

-- Setup vim-notify
require("telescope").load_extension("notify")
require("notify").setup({ background_colour = "#000000" })
-- The schedule_wrap is due to https://github.com/rcarriga/nvim-notify/issues/205
vim.notify = vim.schedule_wrap(require("notify"))

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

require("bufjump").setup()

require("fidget").setup({})

require("dressing").setup({})

require("overseer").setup()

require("guess-indent").setup({})

require("hex").setup()

require("zk").setup({})
require("telescope").load_extension("zk")

vim.api.nvim_create_autocmd("Filetype", {
	pattern = "markdown",
	callback = function()
		require("otter").activate()
	end,
})

require("outline").setup({})

require("hover").setup({
	init = function()
		-- Require providers
		require("hover.providers.lsp")
		require("hover.providers.gh")
		require("hover.providers.gh_user")
	end,
	preview_opts = {
		border = nil,
	},
	-- Whether the contents of a currently open hover window should be moved
	-- to a :h preview-window when pressing the hover keymap.
	preview_window = true,
	title = true,
})

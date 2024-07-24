require("smart-splits").setup({
	resize_mode = {
		quit_key = "<ESC>",
		resize_keys = { "<Left>", "<Down>", "<Up>", "<Right>" },
		-- set to true to silence the notifications
		-- when entering/exiting persistent resize mode
		silent = false,
		-- must be functions, they will be executed when
		-- entering or exiting the resize mode
		hooks = {
			on_enter = nil,
			on_leave = nil,
		},
	},
})

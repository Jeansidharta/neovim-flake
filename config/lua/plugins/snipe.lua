local snipe = require("snipe")

local function producer()
	local bufnr, bufnames = snipe.buffer_producer()
end

vim.api.nvim_create_autocmd("User", {
	pattern = "SnipeCreateBuffer",
	callback = function(args)
		local buf = args.buf
		vim.keymap.set("n", "d", function() end, { buffer = buf, remap = false })
		vim.keymap.set("n", "o", function() end, { buffer = buf, remap = false })
	end,
})

snipe.setup()
vim.keymap.set("n", "gb", function()
	snipe.open_buffer_menu()
end)

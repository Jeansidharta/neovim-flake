local snipe = require("snipe")
snipe.setup()

-- These will receive a value at the end of this file
local open_menu = nil
local delete_menu = nil

local function create_open_menu()
	return snipe.create_menu_toggler(snipe.buffer_producer, function(bufnr, _)
		vim.api.nvim_set_current_buf(bufnr)
	end, { kind = "open" })
end

local function create_delete_menu()
	return snipe.create_menu_toggler(snipe.buffer_producer, function(bufnr, _)
		vim.api.nvim_buf_delete(bufnr, {})
		-- Reopen the delete menu so the user can chain delete
		delete_menu()
	end, { kind = "delete" })
end

local function set_current_win_title(title)
	local window_config = vim.api.nvim_win_get_config(0)
	window_config.title = title
	window_config.width = window_config.width * 2
	vim.api.nvim_win_set_config(0, window_config)
end

local function handle_autocmd_open_menu(bufnr, closeMenu)
	set_current_win_title({ { "Snipe ", "FloatTitle" }, { "[Open]", "@text.emphasis" } })
	vim.keymap.set("n", "<C-d>", function()
		closeMenu()
		delete_menu()
	end, { buffer = bufnr })
end

local function handle_autocmd_delete_menu(bufnr, closeMenu)
	set_current_win_title({ { "Snipe ", "FloatTitle" }, { "[Delete]", "@text.danger" } })
	vim.keymap.set("n", "<C-o>", function()
		closeMenu()
		open_menu()
	end, { buffer = bufnr })
end

vim.api.nvim_create_autocmd("User", {
	pattern = "SnipeCreateBuffer",
	callback = function(args)
		local context = args.data.menu.menu_context or {}
		local closeMenu = args.data.menu.close
		local bufnr = args.buf
		if context.kind == "open" then
			handle_autocmd_open_menu(bufnr, closeMenu)
		elseif context.kind == "delete" then
			handle_autocmd_delete_menu(bufnr, closeMenu)
		end
	end,
})

open_menu = create_open_menu()
delete_menu = create_delete_menu()
vim.keymap.set("n", "gb", open_menu)

local function open_editor_temp_window(initial_lines, filetype)
	local temp_buffer = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(temp_buffer, 0, -1, false, initial_lines)
	vim.api.nvim_buf_set_option(temp_buffer, "filetype", filetype or "")
	-- Requires a 'BufWriteCmd' or "FileWriteCmd" autocmd to write
	vim.api.nvim_buf_set_option(temp_buffer, "buftype", "acwrite")
	-- Allows the user to call :write
	vim.api.nvim_buf_set_name(temp_buffer, "neoclip-temp")

	local function make_ideal_win_config()
		-- Default values are in case neovim is running in headless mode (e.g. during tests)
		local stats = vim.api.nvim_list_uis()[1] or { width = 10, height = 10 }
		local width = stats.width
		local height = stats.height
		local winWidth = math.ceil(width * 0.8)
		local winHeight = math.ceil(height * 0.8)
		return {
			relative = "editor",
			style = "minimal",
			border = "single",
			width = winWidth,
			height = winHeight,
			col = math.ceil((width - winWidth) / 2),
			row = math.ceil((height - winHeight) / 2) - 1,
		}
	end

	local win = vim.api.nvim_open_win(temp_buffer, true, make_ideal_win_config())

	-- Makes sure the window stays at a proper size when vim is resized
	vim.api.nvim_create_autocmd("VimResized", {
		buffer = temp_buffer,
		callback = function()
			vim.api.nvim_win_set_config(win, make_ideal_win_config())
		end,
	})

	-- "BufWriteCmd" and "FileWriteCmd" prevents the file from actually being written to a file
	vim.api.nvim_create_autocmd({ "BufWriteCmd", "FileWriteCmd" }, {
		buffer = temp_buffer,
		callback = function()
			vim.api.nvim_buf_set_option(temp_buffer, "modified", false)
		end,
	})

	vim.api.nvim_create_autocmd({ "WinClosed", "WinLeave" }, {
		buffer = temp_buffer,
		callback = function()
			vim.api.nvim_buf_delete(temp_buffer, { force = true })
		end,
	})
end

-- local function get_visual_selection_position()
-- 	local vstart = vim.fn.getpos("'<")
-- 	local vend = vim.fn.getpos("'>")
--
-- 	local line_start = vstart[2]
-- 	local line_end = vend[2]
-- 	local col_start = vstart[3]
-- 	local col_end = vend[3]
--
-- 	return {
-- 		start = { line_start, col_start },
-- 		finish = { line_end, col_end },
-- 		buf = vstart[1],
-- 	}
-- end

local function get_visual_selection_position()
	local vstart = vim.fn.getpos("v")
	local vend = vim.fn.getcurpos()

	local line_start = vstart[2]
	local line_end = vend[2]
	local col_start = vstart[3]
	local col_end = vend[3]

	return {
		start = { line_start, col_start },
		finish = { line_end, col_end },
		buf = vstart[1],
	}
end

local function get_visual_selection_lines()
	local visual_pos = get_visual_selection_position()
	return vim.api.nvim_buf_get_lines(visual_pos.buf, visual_pos.start[1] - 1, visual_pos.finish[1], false)
end

local function get_visual_selection_text()
	local visual_pos = get_visual_selection_position()
	return vim.api.nvim_buf_get_text(
		visual_pos.buf,
		visual_pos.start[1] - 1,
		visual_pos.start[2] - 1,
		visual_pos.finish[1] - 1,
		visual_pos.finish[2],
		{}
	)
end

local function find_project_root()
	local buf_path = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
	return vim.fs.dirname(
		vim.fs.find(".git/", { upward = true, path = buf_path })[1] or vim.fs.find(".git", { upward = true })[1] or "."
	)
end

local function tbl_find(f, l)
	for _, v in ipairs(l) do
		if f(v) then
			return v
		end
	end
	return nil
end

local function keymap(opts)
	local mode = opts.mode or { "n" }
	local lhs = opts[1]
	local rhs = opts[2]
	local noremap = opts.noremap or true
	local silent = opts.silent or true
	local desc = opts.desc
	vim.keymap.set(mode, lhs, rhs, { noremap = noremap, silent = silent, desc = desc })
end

local function keymaps(optsArr)
	for _, opt in pairs(optsArr) do
		keymap(opt)
	end
end

return {
	open_editor_temp_window = open_editor_temp_window,
	get_visual_selection_position = get_visual_selection_position,
	get_visual_selection_text = get_visual_selection_text,
	get_visual_selection_lines = get_visual_selection_lines,
	find_project_root = find_project_root,
	tbl_find = tbl_find,
	keymap = keymap,
	keymaps = keymaps,
}

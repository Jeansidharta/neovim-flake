local utils = require("config.utils")

local function clear_notifications()
	require("notify").dismiss({})
end

local function toggle_inlay_hints()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end

local function toggle_quick_fix()
	local qf_exists = false
	for _, win in pairs(vim.fn.getwininfo()) do
		if win["quickfix"] == 1 then
			qf_exists = true
		end
	end
	if qf_exists == true then
		vim.cmd("cclose")
		return
	elseif vim.tbl_isempty(vim.fn.getqflist()) then
		vim.notify("Quick fix list is empty", vim.log.levels.WARN)
	else
		vim.cmd("copen")
	end
end

local function list_workspace_folders()
	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end

local function new_file_selector()
	local buffers = vim.api.nvim_list_bufs()
	local commands_buf = utils.tbl_find(function(i)
		return vim.api.nvim_buf_get_name(i) == "cmdmd://main"
	end, buffers)
	if not commands_buf then
		commands_buf = vim.api.nvim_create_buf(true, false)
		vim.api.nvim_buf_set_option(commands_buf, "filetype", "markdown")
		vim.api.nvim_buf_set_name(commands_buf, "cmdmd://main")
		vim.api.nvim_create_autocmd({ "BufWriteCmd", "FileWriteCmd" }, {
			buffer = commands_buf,
			callback = function()
				vim.api.nvim_buf_set_option(commands_buf, "modified", false)
			end,
		})
	end

	local open_win = utils.tbl_find(function(i)
		return vim.api.nvim_win_get_buf(i) == commands_buf
	end, vim.api.nvim_list_wins())

	if open_win then
		vim.api.nvim_win_close(open_win, true)
	else
		vim.cmd(vim.api.nvim_replace_termcodes("normal! :vsplit<CR>", true, true, true))
		vim.api.nvim_win_set_buf(0, commands_buf)
	end
end

local function show_next_diagnostic()
	local function get_closest_diagnostic()
		local next = vim.diagnostic.get_next()
		local prev = vim.diagnostic.get_prev()

		if next == nil and prev == nil then
			return nil
		elseif next == nil then
			return prev
		elseif prev == nil then
			return next
		end

		local curr_buffer = vim.api.nvim_get_current_buf()

		if curr_buffer ~= next.buffer and curr_buffer ~= prev.buffer then
			return next
		elseif curr_buffer ~= next.buffer then
			return prev
		elseif curr_buffer ~= prev.buffer then
			return next
		end

		local curpos = vim.fn.getcurpos()
		local curline = curpos[2]
		local curcol = curpos[3]

		if curline ~= next.lnum and curline == prev.lnum then
			return prev
		elseif curline == next.lnum and curline ~= prev.lnum then
			return next
		elseif curline == next.lnum and curline == prev.lnum then
			if math.abs(curcol - next.col) < math.abs(curcol - prev.col) then
				return next
			else
				return prev
			end
		else
			if math.abs(curline - next.lnum) < math.abs(curline - prev.lnum) then
				return next
			else
				return prev
			end
		end
	end

	local closest_diagnostic = get_closest_diagnostic()
	if closest_diagnostic == nil then
		vim.notify("No diagnostics available")
	else
		utils.open_editor_temp_window(vim.split(closest_diagnostic.message, "\n"), "text")
	end
end

utils.keymaps({
	{ "<Tab>",            ":w<CR>",                         desc = "Save buffer" },
	{ "<leader>l",        ":messages<CR>",                  desc = "Show messages" },
	{ "<leader>n",        clear_notifications,              desc = "Clear all notifications" },
	{ "<S-Tab>",          ":lua vim.lsp.buf.format()<CR>",  desc = "Format buffer" },

	------------------ Splits --------------------
	{ "<leader>s<Up>",    ":split<CR><c-w>k<CR>",           desc = "Split up" },
	{ "<leader>s<Down>",  ":split<CR>",                     desc = "Split down" },
	{ "<leader>s<Left>",  ":vsplit<CR><c-w>h<CR>",          desc = "Split left" },
	{ "<leader>s<Right>", ":vsplit<CR>",                    desc = "Split right" },

	------------------ DIAGNOSTICS --------------------
	{ "<leader>dn",       vim.diagnostic.goto_next,         desc = "Go to next diagnostics" },
	{ "<leader>dN",       vim.diagnostic.goto_prev,         desc = "Go to prev diagnostics" },
	{ "<leader>do",       vim.diagnostic.open_float,        desc = "Open diagnostics float" },
	{ "<leader>dq",       vim.diagnostic.setloclist,        desc = "Send diagnostics to qf list" },
	{ "<leader>di",       toggle_inlay_hints,               desc = "Toggle inlay hints" },

	-------------- QUICK FIX --------------------------
	{ "<leader>qt",       toggle_quick_fix,                 desc = "Toggle Quick Fix" },
	{ "<leader>qo",       ":copen<CR>",                     desc = "Open Quick Fix" },
	{ "<leader>qn",       ":cnext<CR>",                     desc = "Next Quick Fix" },
	{ "<leader>qN",       ":cprev<CR>",                     desc = "Prev Quick Fix" },
	{ "<leader>qf",       ":cfirst<CR>",                    desc = "First item in Quick Fix" },
	{ "<leader>ql",       ":clast<CR>",                     desc = "Last item in Quick Fix" },

	-------------- LSP --------------------------
	{ "gD",               vim.lsp.buf.declaration,          desc = "Go to declaration" },
	{ "gd",               vim.lsp.buf.definition,           desc = "Go to definition" },
	{ "gt",               vim.lsp.buf.type_definition,      desc = "Go to type definition" },
	{ "gi",               vim.lsp.buf.implementation,       desc = "Go to implementation" },
	{ "gr",               vim.lsp.buf.references,           desc = "Go to references" },
	{ "<C-k>",            vim.lsp.buf.signature_help,       desc = "Signature help" },
	{ "<space>a",         vim.lsp.buf.code_action,          desc = "Code action" },
	{ "<space>wl",        list_workspace_folders,           desc = "List workspace folders" },
	{ "<space>rn",        vim.lsp.buf.rename,               desc = "Rename symbol" },

	----------------- OTHER -------------------
	{ "++",               "\"zyymzo```<ESC>'z==O```<ESC>P", desc = "Run current line" },
	{ "<leader>io",       new_file_selector,                desc = "New file selector" },
	{ "<leader>df",       show_next_diagnostic,             desc = "Run current line" },
	{ "<C-H>",            ":nohlsearch<CR>",                desc = "Remove highlights" },

	----------------- Plugins -------------------
	-- Neoclip
	{ "<leader>tc",       ":Telescope neoclip<Return>",     desc = "Open neoclip in telescope" },
	{
		"<leader>tm",
		require("telescope").extensions.macroscope.default,
		desc = "Open macroscope in telescope",
	},
	-- Hover
	{ "K",          require("hover").hover,        desc = "hover.nvim" },
	{ "<leader>k",  require("hover").hover_select, desc = "hover.nvim (select)" },
	-- Luasnip
	{ "<leader>zn", "<Plug>luasnip-jump-next",     noremap = true,              desc = "LuaSnip Next" },
	{ "<leader>zN", "<Plug>luasnip-jump-prev",     noremap = true,              desc = "LuaSnip Prev" },
	{
		"<C-,>",
		function()
			require("luasnip").jump(1)
		end,
		desc = "LuaSnip jump to next slot",
	},
	{
		"<C-.>",
		function()
			require("luasnip").jump(-1)
		end,
		desc = "LuaSnip jump to previous slot",
	},
	{
		"<C-,>",
		function()
			require("luasnip").jump(1)
		end,
		desc = "LuaSnip jump to next slot",
		mode = { "i" },
	},
	{
		"<C-.>",
		function()
			require("luasnip").jump(-1)
		end,
		desc = "LuaSnip jump to previous slot",
		mode = { "i" },
	},
	-- Mdeval
	{ "<leader>ii", require("mdeval").eval_code_block, desc = "Evaluate code block" },
	-- Smart Splits
	{
		"<leader><leader>wr",
		require("smart-splits").start_resize_mode,
		desc = "start resize mode",
	},
	{
		"<C-Left>",
		require("smart-splits").move_cursor_left,
		desc = "move cursor left",
	},
	{
		"<C-Down>",
		require("smart-splits").move_cursor_down,
		desc = "move cursor down",
	},
	{
		"<C-Up>",
		require("smart-splits").move_cursor_up,
		desc = "move cursor up",
	},
	{
		"<C-Right>",
		require("smart-splits").move_cursor_right,
		desc = "move cursor right",
	},
	{
		"<C-S-Left>",
		function()
			require("smart-splits").swap_buf_left()
			require("smart-splits").move_cursor_left()
		end,
		desc = "swap buf left",
	},
	{
		"<C-S-Down>",
		function()
			require("smart-splits").swap_buf_down()
			require("smart-splits").move_cursor_down()
		end,
		desc = "swap buf down",
	},
	{
		"<C-S-Up>",
		function()
			require("smart-splits").swap_buf_up()
			require("smart-splits").move_cursor_up()
		end,
		desc = "swap buf up",
	},
	{
		"<C-S-Right>",
		function()
			require("smart-splits").swap_buf_right()
			require("smart-splits").move_cursor_right()
		end,
		desc = "swap buf right",
	},
	-- Lsp lines
	{
		"<leader>dl",
		function()
			local is_lines_set = vim.diagnostic.config().virtual_lines
			if is_lines_set then
				vim.diagnostic.config({
					virtual_lines = false,
					virtual_text = true,
				})
			else
				vim.diagnostic.config({
					virtual_lines = true,
					virtual_text = false,
				})
			end
		end,
		desc = "Toggle lsp_lines",
	},
	-- Oil
	{ "-",          require("oil").open,               desc = "Open oil.nvim" },
	-- Substitute
	{ "<Leader>r",  require("substitute").operator,    desc = "Substitution operator" },
	{ "<Leader>rr", require("substitute").line,        desc = "Substitute line with register" },
	{ "<Leader>R",  require("substitute").eol,         desc = "Substitute until EOL with register" },
	-- Overseer
	{ "<leader>or", ":OverseerRun<Return>",            desc = "Run overseer command" },
	{ "<leader>ot", ":OverseerToggle left<Return>",    desc = "Open overseer panel" },
})

vim.api.nvim_create_autocmd("Filetype", {
	pattern = "openscad",
	callback = function()
		vim.keymap.set("n", "<leader>x", function()
			local filepath = vim.fn.expand("%:p")
			local filename = vim.fn.expand("%:t")
			local task =
				require("overseer").new_task({ cmd = "openscad", args = { filepath }, name = "OpenSCAD " .. filename })
			require("overseer").run_action(task, "start")
		end)
	end,
})

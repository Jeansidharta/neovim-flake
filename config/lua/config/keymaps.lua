local utils = require("config.utils")

local function clear_notifications()
	require("notify").dismiss({})
end

local function hover()
	vim.lsp.buf.hover({ border = "rounded" })
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
		vim.cmd.cclose()
		return
	elseif vim.tbl_isempty(vim.fn.getqflist()) then
		vim.notify("Quick fix list is empty", vim.log.levels.WARN)
	else
		vim.cmd.copen()
	end
end

local function new_file_selector()
	local buffers = vim.api.nvim_list_bufs()
	local commands_buf = utils.tbl_find(function(i)
		return vim.api.nvim_buf_get_name(i) == "cmdmd://main"
	end, buffers)
	if not commands_buf then
		commands_buf = vim.api.nvim_create_buf(true, false)
		vim.api.nvim_set_option_value("filetype", "markdown", { buf = commands_buf })
		vim.api.nvim_buf_set_name(commands_buf, "cmdmd://main")
		vim.api.nvim_create_autocmd({ "BufWriteCmd", "FileWriteCmd" }, {
			buffer = commands_buf,
			callback = function()
				vim.api.nvim_set_option_value("modified", false, { buf = commands_buf })
			end,
		})
	end

	local open_win = utils.tbl_find(function(i)
		return vim.api.nvim_win_get_buf(i) == commands_buf
	end, vim.api.nvim_list_wins())

	if open_win then
		vim.api.nvim_win_close(open_win, true)
	else
		vim.cmd.vsplit()
		vim.api.nvim_win_set_buf(0, commands_buf)
	end
end

-- Should be invoked while on a visual selection
-- Will take the text selected and create a new zk note with that text as a title.
-- The originally selected note will be replaced by a link to the note.
local function turnSelectionIntoZkLink()
	local zk = require("zk.api")
	local title = utils.get_visual_selection_text()
	if #title > 1 then
		vim.notify("Cannot create note with a multi-line title", vim.log.levels.WARN)
		return
	end
	---@diagnostic disable-next-line: cast-local-type
	title = vim.trim(title[1])
	local location = utils.get_visual_selection_position()
	zk.new(
	-- Path to the note. If nil, zk will create one itself.
		nil,
		-- dryRun makes sure the note is not created in the filesystem. This allows the user to change
		-- their mind before actually saving the note.
		{ title = title, dryRun = true },
		function(err, note)
			if err ~= nil then
				vim.notify("Failed to create link", vim.log.levels.ERROR)
				vim.print(err)
				return
			end
			vim.notify("Created note " .. note.path)
			-- Replace the selected text with the link
			vim.api.nvim_buf_set_text(
				location.buf,
				location.start[1] - 1,
				location.start[2] - 1,
				location.finish[1] - 1,
				location.finish[2],
				{ "[" .. title .. "](" .. vim.fs.basename(note.path) .. ")" }
			)
			vim.cmd.write() -- Save current buffer. This is to make sure the recently placed link is permanently saved
			vim.cmd.edit(note.path) -- Open new note for editing
			-- Since the note wasn't saved in the filesystem (because of the dryRun) we have to
			-- fill its content ourselves.
			vim.api.nvim_buf_set_lines(0, 0, 0, false, vim.split(note.content, "\n"))
		end
	)
end
local function toggle_lsp_lines()
	local is_lines_set = vim.diagnostic.config().virtual_lines
	if is_lines_set then
		vim.diagnostic.config({
			virtual_lines = false,
			virtual_text  = true,
		})
	else
		vim.diagnostic.config({
			virtual_lines = true,
			virtual_text  = false,
		})
	end
end

local function toggle_diagnostics()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

local function toggle_codelens()
	vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end

local function toggle_semantic_tokens()
	vim.lsp.semantic_tokens.enable(not vim.lsp.semantic_tokens.is_enabled())
end

local function edit_register()
	-- Target register will be whatever next character the user types
	local register = string.lower(vim.fn.getchar(-1, { number = false }))
	local contents = vim.fn.keytrans(vim.fn.getreg(register))

	vim.ui.input({ prompt = "Edit register " .. register, default = contents }, function(newValueRaw)
		-- If user cancelled
		if newValueRaw == nil then
			return
		end
		-- sets reg_recorded to target register, so we can then use Q to use it. See :help reg_recorded
		vim.cmd.normal("q" .. register .. "q")

		local newValue = vim.api.nvim_replace_termcodes(newValueRaw, true, true, true)
		vim.fn.setreg(register, newValue)
	end)
end

local function toggle_fyler()
	if vim.startswith(vim.api.nvim_buf_get_name(0), "fyler://") then
		local old_cwd = vim.api.nvim_buf_get_name(0):gsub("^fyler://", "")
		require("fyler").open({ cwd = vim.fs.dirname(old_cwd:gsub("(.+)/$", "%1")) })
		return
	end

	local bufs = vim.iter(vim.api.nvim_list_bufs())
		:filter(function(buf)
			return vim.startswith(vim.api.nvim_buf_get_name(buf), "fyler://")
		end)
		:totable()

	if vim.tbl_isempty(bufs) then
		require("fyler").open({})
	else
		vim.iter(bufs):map(function(buf)
			vim.api.nvim_buf_delete(buf, { force = true })
		end)
	end
end

local function format_buffer()
	vim.lsp.buf.format()
	-- For some reason, format will sometimes disable diagnostic?
	vim.diagnostic.enable(vim.diagnostic.is_enabled())
end

local function dap_set_breakpoint()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end
local function dap_list_breakpoints()
	require("dap").list_breakpoints()
	vim.cmd.copent()
end
local function dap_hover()
	require("dap.ui.widgets").hover(nil, { border = "rounded" })
end
local function dap_frames()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames, { border = "rounded" })
end

local function dap_scopes()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes, { border = "rounded" })
end

local function diagostic_qflist_all()
	vim.fn.setqflist(vim.diagnostic.toqflist(vim.diagnostic.get()), "r")
end

utils.keymaps({
	-- ========== Splits ===========
	{ "<leader>s<Up>",    ":split<CR><c-w>k<CR>",    desc = "Split up" },
	{ "<leader>s<Down>",  ":split<CR>",              desc = "Split down" },
	{ "<leader>s<Left>",  ":vsplit<CR><c-w>h<CR>",   desc = "Split left" },
	{ "<leader>s<Right>", ":vsplit<CR>",             desc = "Split right" },
	-- ========== Diagnostics ==========
	{ "<leader>dq",       vim.diagnostic.setqflist,  desc = "Send diagnostics to qf list" },
	{ "<leader>dQ",       diagostic_qflist_all,      desc = "Send diagnostics to qf list" },
	{ "<leader>df",       vim.diagnostic.open_float, desc = "Show diagnostics on current line" },
	{ "<leader>dd",       toggle_diagnostics,        desc = "Toggle diagnostics" },
	{ "<leader>di",       toggle_inlay_hints,        desc = "Toggle inlay hints" },
	{ "<leader>dc",       toggle_codelens,           desc = "Toggle Codelens" },
	{ "<leader>ds",       toggle_semantic_tokens,    desc = "Toggle Semantic tokens highlighting" },
	-- ========== Quick Fix ==========
	{ "<leader>cc",       toggle_quick_fix,          desc = "Toggle Quick Fix" },
	-- ========== LSP ==========
	{ "grD",              vim.lsp.buf.declaration,   desc = "Go to declaration" },
	{ "grd",              vim.lsp.buf.definition,    desc = "Go to definition" },
	{
		"<C-k>",
		function()
			vim.lsp.buf.signature_help({ border = "rounded" })
		end,
		desc = "Signature help"
	},
	-- ========== Treesitter ==========
	{
		"<C-Up>",
		"an",
		desc = "Outter treesitter node",
		mode = "v",
		noremap = false,
		remap = true
	},
	{
		"<C-Down>",
		"in",
		desc = "inner treesitter node",
		mode = "v",
		noremap = false,
		remap = true
	},
	{
		"<C-Left>",
		"[n",
		desc = "previous treesitter node",
		mode = "v",
		noremap = false,
		remap = true
	},
	{
		"<C-Right>",
		"]n",
		desc = "next treesitter node",
		mode = "v",
		noremap = false,
		remap = true
	},
	{ "<C-S-Right>", vim.cmd.TSNavNext,                        desc = "Swap current Treesitter node with the next",          mode = "v" },
	{ "<C-S-Left>",  vim.cmd.TSNavPrev,                        desc = "Swap current Treesitter node with the previous",      mode = "v" },
	-- ========== Misc ==========
	{ "<Tab>",       vim.cmd.write,                            desc = "Save buffer" },
	{ "<leader>l",   vim.cmd.messages,                         desc = "Show messages" },
	{ "<leader>n",   clear_notifications,                      desc = "Clear all notifications" },
	{ "/",           "<esc>/\\%V",                             desc = "search within selection",                             mode = "v" },
	{ "<leader>e",   edit_register,                            desc = "Write register contents into line" },
	{ "<S-Tab>",     format_buffer,                            desc = "Format buffer" },
	{ "K",           hover,                                    desc = "hover.nvim" },
	{ "++",          '"zyymzo```<ESC>\'z==O```<ESC>"zP',       desc = "Run current line" },
	{ "<leader>io",  new_file_selector,                        desc = "New file selector" },
	{ "<C-H>",       vim.cmd.nohlsearch,                       desc = "Remove highlights" },

	-- ==================== Plugins ====================
	-- ========== Atone.nvim ==========
	{ "<leader>u",   ":Atone toggle<CR>",                      desc = "Toggle Atone" },
	-- ========== Luasnip ==========
	{ "<leader>zn",  "<Plug>luasnip-jump-next",                desc = "LuaSnip Next" },
	{ "<leader>zN",  "<Plug>luasnip-jump-prev",                desc = "LuaSnip Prev" },
	-- ========== Mdeval ==========
	{ "<leader>ii",  require("mdeval").eval_code_block,        desc = "Evaluate code block" },
	-- ========== Lsp lines ==========
	{ "<leader>dl",  toggle_lsp_lines,                         desc = "Toggle lsp_lines" },
	-- ========== Fyler ==========
	{ "-",           toggle_fyler,                             desc = "Toggle fyler.nvim" },
	-- ========== ZK: zettelkasten ==========
	{ "<leader>zn",  vim.cmd.ZkNew,                            desc = "Create a new zk note" },
	{ "<leader>zn",  turnSelectionIntoZkLink,                  desc = "New note with visual selection",                      mode = "v" },
	-- ========== fzf ==========
	{ "<leader>ff",  require("fzf-lua").files,                 desc = "FZF Files" },
	{ "<leader>fg",  require("fzf-lua").live_grep_native,      desc = "FZF Ripgrep" },
	{ "<leader>fp",  require("fzf-lua").resume,                desc = "Resume FZF search" },
	{ "<leader>f:",  require("fzf-lua").jumps,                 desc = "Resume FZF search" },
	{ "<leader>fd",  require("fzf-lua").diagnostics_workspace, desc = "FZF Workspace Diagnostics" },
	{ "<leader>fh",  require("fzf-lua").helptags,              desc = "FZF Help tags" },
	{ "<leader>fb",  require("fzf-lua").builtin,               desc = "FZF Builtins" },
	-- ========== bufjump ==========
	{ "<C-i>",       require("bufjump").forward,               desc = "Jump to the next buffer in the jump list" },
	{ "<C-o>",       require("bufjump").backward,              desc = "Jump to the previous buffer in the jump list" },
	{ "<C-S-o>",     require("bufjump").backward_same_buf,     desc = "Jump back in the jump list within the same buffer" },
	{ "<C-S-i>",     require("bufjump").forward_same_buf,      desc = "Jump forward in the jump list within the same buffer" },
	-- ========== dap ==========
	{ "<F5>",        require("dap").continue,                  desc = "DAP: Start debug session" },
	{ "<F10>",       require("dap").step_over,                 desc = "DAP: Step over" },
	{ "<F11>",       require("dap").step_into,                 desc = "DAP: Step into" },
	{ "<F12>",       require("dap").step_out,                  desc = "DAP: Step out" },
	{ "<Leader>;a",  require("dap").set_exception_breakpoints, desc = "DAP: Set Exception Breakpoints" },
	{ "<Leader>;b",  require("dap").toggle_breakpoint,         desc = "DAP: Toggle Breakpoint" },
	{ "<Leader>;;",  require("dap").repl.toggle,               desc = "DAP: Toggle Repl" },
	{ "<Leader>;B",  dap_set_breakpoint,                       desc = "DAP: Set Logging Breakpoint" },
	{ "<Leader>;l",  dap_list_breakpoints,                     desc = "DAP: List Breakpoints" },
	{ "<Leader>;k",  dap_hover,                                desc = "DAP: hover" },
	{ "<Leader>;f",  dap_frames,                               desc = "DAP: Show frames" },
	{ "<Leader>;s",  dap_scopes,                               desc = "DAP: Show scopes" },
	-- ========== outline ==========
	{ "<leader>/",   require("outline").toggle,                desc = "Toggle outline" },
})

-- Forces neovim to add a jumplist entry whenever the user jumps more than
-- `max_distance` up or down using a could (e.g. in normal mode: `10j`)
local max_distance = 3
for _, key in pairs({ "<Down>", "<Up>", "j", "k" }) do
	vim.keymap.set({ "n", "v" }, key, function()
		if vim.v.count > max_distance then
			return "m'" .. vim.v.count .. key
		end
		return key
	end, { expr = true })
end

-- Set some bindings to run SQL queries using the `usql` cli program.
local custom_sql_group = vim.api.nvim_create_augroup("custom_sql", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = custom_sql_group,
	pattern = "sql",
	desc = "Add sql bindings",
	-- callback = function(_id, _event, _group, _match, buf, _file, _data)
	callback = function(args)
		local buf = args.buf

		vim.keymap.set("v", "!+", function()
			local text = table.concat(utils.get_visual_selection_lines(), "\n")
			local result = vim.split(vim.fn.system({ "usql", "database_sqlite", "-c", text }), "\n")
			utils.open_editor_temp_window(result)
		end, {
			desc = "Send to database",
			remap = false,
			buffer = buf,
		})

		vim.keymap.set("n", "!+", function()
			local cursor_line = vim.fn.getcurpos()[2]
			local text = table.concat(vim.api.nvim_buf_get_lines(buf, cursor_line - 1, cursor_line, false), "\n")
			local result = vim.split(vim.fn.system({ "uql", "database_sqlite", "-c", text }), "\n")
			utils.open_editor_temp_window(result)
		end, {
			desc = "Send to database",
			remap = false,
			buffer = buf,
		})
	end,
})

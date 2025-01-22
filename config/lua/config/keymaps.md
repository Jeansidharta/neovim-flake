# Keymaps

This file is supposed to contain all of the user's keybinds. This is so it's
easy to find or grep for a keybind.

## Misc actions

Some actions that are at some point attached to a keybind.

```lua
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

-- Should be invoked while on a visual selection
-- Will take the text selected and create a new zk note with that text as a title.
-- The originally selected note will be replaced by a link to the note.
local function turnSelectionIntoZkLink ()
	local zk = require("zk.api")
	local title = utils.get_visual_selection_text()
	if #title > 1 then
		vim.notify("Cannot create note with a multi-line title", vim.log.levels.WARN);
		return;
	end
	title = vim.trim(title[1])
	local location = utils.get_visual_selection_position()
	zk.new(
		-- Path to the note. If nil, zk will create one itself.
		nil,
		-- dryRun makes sure the note is not created in the filesystem. This allows the user to change
		-- their mind before actually saving the note.
		{ title = title, dryRun = true },
		function (err, note)
			if err ~= nil then
				vim.notify("Failed to create link", vim.log.levels.ERROR)
				vim.print(err)
				return
			end
			vim.notify("Created note " .. note.path);
			-- Replace the selected text with the link
			vim.api.nvim_buf_set_text(
				location.buf,
				location.start[1] - 1,
				location.start[2] - 1,
				location.finish[1] - 1,
				location.finish[2],
				{"["..title.."]("..vim.fs.basename(note.path)..")"}
			)
			vim.cmd[[write]] -- Save current buffer. This is to make sure the recently placed link is permanently saved
			vim.cmd([[edit ]] .. note.path) -- Open new note for editing
			-- Since the note wasn't saved in the filesystem (because of the dryRun) we have to
			-- fill its content ourselves.
			vim.api.nvim_buf_set_lines(0, 0, 0, false, vim.split(note.content, "\n"))
		end
	);
end

local function toggle_lsp_lines ()
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
end
```

## Actual keymaps

### Misc

```lua
utils.keymaps({	{ "<Tab>",            ":w<CR>",                         desc = "Save buffer" },
	{ "<leader>l",        ":messages<CR>",                  desc = "Show messages" },
	{ "<leader>n",        clear_notifications,              desc = "Clear all notifications" },
	{ "<S-Tab>",          ":lua vim.lsp.buf.format()<CR>",  desc = "Format buffer" },
```

### Splits

```lua
	{ "<leader>s<Up>",    ":split<CR><c-w>k<CR>",           desc = "Split up" },
	{ "<leader>s<Down>",  ":split<CR>",                     desc = "Split down" },
	{ "<leader>s<Left>",  ":vsplit<CR><c-w>h<CR>",          desc = "Split left" },
	{ "<leader>s<Right>", ":vsplit<CR>",                    desc = "Split right" },

```

### Diagnostics

```lua
	{ "<leader>dn",       vim.diagnostic.goto_next,         desc = "Go to next diagnostics" },
	{ "<leader>dN",       vim.diagnostic.goto_prev,         desc = "Go to prev diagnostics" },
	{ "<leader>do",       vim.diagnostic.open_float,        desc = "Open diagnostics float" },
	{ "<leader>dq",       vim.diagnostic.setloclist,        desc = "Send diagnostics to qf list" },
	{ "<leader>di",       toggle_inlay_hints,               desc = "Toggle inlay hints" },

```

### Quick Fix

```lua
	{ "<leader>qt",       toggle_quick_fix,                 desc = "Toggle Quick Fix" },
	{ "<leader>qo",       ":copen<CR>",                     desc = "Open Quick Fix" },
	{ "<leader>qn",       ":cnext<CR>",                     desc = "Next Quick Fix" },
	{ "<leader>qN",       ":cprev<CR>",                     desc = "Prev Quick Fix" },
	{ "<leader>qf",       ":cfirst<CR>",                    desc = "First item in Quick Fix" },
	{ "<leader>ql",       ":clast<CR>",                     desc = "Last item in Quick Fix" },
```

### LSP

```lua
	{ "gD",               vim.lsp.buf.declaration,          desc = "Go to declaration" },
	{ "gd",               vim.lsp.buf.definition,           desc = "Go to definition" },
	{ "gt",               vim.lsp.buf.type_definition,      desc = "Go to type definition" },
	{ "gi",               vim.lsp.buf.implementation,       desc = "Go to implementation" },
	{ "gr",               vim.lsp.buf.references,           desc = "Go to references" },
	{ "<C-k>",            vim.lsp.buf.signature_help,       desc = "Signature help" },
	{ "<space>a",         vim.lsp.buf.code_action,          desc = "Code action" },
	{ "<space>wl",        list_workspace_folders,           desc = "List workspace folders" },
	{ "<space>rn",        vim.lsp.buf.rename,               desc = "Rename symbol" },

```

### Other

````lua
	{ "++",               "\"zyymzo```<ESC>'z==O```<ESC>P", desc = "Run current line" },
	{ "<leader>io",       new_file_selector,                desc = "New file selector" },
	{ "<leader>df",       show_next_diagnostic,             desc = "Run current line" },
	{ "<C-H>",            ":nohlsearch<CR>",                desc = "Remove highlights" },
````

### Plugins

#### Telescope Pickers

```lua
	{ "<leader>tt",  ":Telescope<CR>",                                desc = "Open telescope pickers" },
	{ "<leader>twt", ":Telescope live_grep<CR>",                      desc = "Open live grep" },
	{ "<leader>th",  ":Telescope help_tags<CR>",                      desc = "Open help window" },
	{ "<leader>tp",  require("telescope.builtin").resume,             desc = "Resume last picker" },
	{ "<leader>tr", ":Telescope lsp_references<CR>", noremap = true, desc = "Open LSP references", },
```

##### Diagnostics

```lua
	{ "<leader>tdd", "<cmd>Telescope diagnostics<cr>",                desc = "Open diagnostics" },
	{ "<leader>tdd", "<cmd>Telescope diagnostics<cr>",                desc = "Open diagnostics" },
	{ "<leader>tdh", "<cmd>Telescope diagnostics severity=HINT<cr>",  desc = "Open diagnostics for errors" },
	{ "<leader>tdi", "<cmd>Telescope diagnostics severity=INFO<cr>",  desc = "Open diagnostics for errors" },
	{ "<leader>tdw", "<cmd>Telescope diagnostics severity=WARN<cr>",  desc = "Open diagnostics for errors" },
	{ "<leader>tde", "<cmd>Telescope diagnostics severity=ERROR<cr>", desc = "Open diagnostics for errors" },
```

##### Notify

```lua
	{ "<leader>tn",  ":Telescope notify<CR>",                         desc = "Open notifications history" },
```

##### Git

```lua
	{ "<leader>tgb", ":Telescope telescope_git all_branches<CR>",     desc = "Open branch list" },
	{ "<leader>tgd", ":Telescope git_bcommits<CR>",                   desc = "Open git commits for current file" },
	{ "<leader>tgc", ":Telescope git_commits<CR>",                    desc = "Open git commits" },
	{ "<leader>tgs", ":Telescope git_status<CR>",                     desc = "Open git status" },
	{ "<leader>tgf", ":Telescope git_files<CR>",                      desc = "Open git files" },
```

#### Neoclip

```lua
	{ "<leader>tc",       ":Telescope neoclip<Return>",     desc = "Open neoclip in telescope" },
	{ "<leader>tm", require("telescope").extensions.macroscope.default, desc = "Open macroscope in telescope", },
```

#### Hover

```lua
	{ "K",          require("hover").hover,        desc = "hover.nvim" },
	{ "<leader>k",  require("hover").hover_select, desc = "hover.nvim (select)" },
```

#### Luasnip

```lua
	-- { "<leader>zn", "<Plug>luasnip-jump-next",     noremap = true,              desc = "LuaSnip Next" },
	-- { "<leader>zN", "<Plug>luasnip-jump-prev",     noremap = true,              desc = "LuaSnip Prev" },
```

#### Mdeval

```lua
	{ "<leader>ii", require("mdeval").eval_code_block, desc = "Evaluate code block" },
```

#### Treewalker

```lua
-- movement
	{ '<C-Up>', '<cmd>Treewalker Up<cr>', silent = true },
	{ '<C-Down>', '<cmd>Treewalker Down<cr>', silent = true },
	{ '<C-Left>', '<cmd>Treewalker Left<cr>', silent = true },
	{ '<C-Right>', '<cmd>Treewalker Right<cr>', silent = true },

-- swapping
	{ '<leader><C-Up>', '<cmd>Treewalker SwapUp<cr>', silent = true },
	{ '<leader><C-Down>', '<cmd>Treewalker SwapDown<cr>', silent = true },
	{ '<leader><C-Left>', '<cmd>Treewalker SwapLeft<CR>', silent = true },
	{ '<leader><C-Right>', '<cmd>Treewalker SwapRight<CR>', silent = true },
```

#### Lsp lines

```lua
	{ "<leader>dl", toggle_lsp_lines, desc = "Toggle lsp_lines", },
```

#### Oil

```lua
	-- Oil
	{ "-",          require("oil").open,               desc = "Open oil.nvim" },
```

#### Substitute

```lua
	{ "<Leader>r",  require("substitute").operator,    desc = "Substitution operator" },
	{ "<Leader>rr", require("substitute").line,        desc = "Substitute line with register" },
	{ "<Leader>R",  require("substitute").eol,         desc = "Substitute until EOL with register" },
```

#### Overseer

```lua
	{ "<leader>or", ":OverseerRun<Return>",            desc = "Run overseer command" },
	{ "<leader>ot", ":OverseerToggle left<Return>",    desc = "Open overseer panel" },
```

#### ZK: zettelkasten

```lua
	{ "<leader>zo", ":Telescope zk notes<Return>",     desc = "Open a zk note" },
	{ "<leader>zn", ":ZkNew<Return>",                  desc = "Create a new zk note" },
	{ "<leader>zt", ":Telescope zk tags<Return>",      desc = "List all tags" },
	{ "<leader>zn", turnSelectionIntoZkLink ,          desc = "Create note with visual selection", mode = "v" },
```

#### bufjump

```lua
	{ "<C-i>", require('bufjump').forward,             desc = "Jump to the next buffer in the jump list" },
	{ "<C-o>", require('bufjump').backward,            desc = "Jump to the previous buffer in the jump list" },
	{ "<C-.>", require('bufjump').backward_same_buf,   desc = "Jump back in the jump list within the same buffer" },
	{ "<C-,>", require('bufjump').forward_same_buf,    desc = "Jump forward in the jump list within the same buffer" },
```

#### outline

```lua
	{ "<leader>/", "<cmd>Outline<CR>", desc = "Toggle outline"},
})
```

## Filetype specific keybinds

```lua
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

```

Run an entire lua file through neovim. Good for testing new plugins

```lua
vim.api.nvim_create_autocmd("filetype", {
	pattern = { "lua" },
	callback = function()
		vim.keymap.set("n", "<leader>ff", function()
			vim.cmd([[luafile %]])
		end)
	end,
})

```

Forces neovim to add a jumplist entry whenever the user jumps more than
`max_distance` up or down using a could (e.g. in normal mode: `10j`)

```lua
local max_distance = 3

for _, key in pairs({ "<Down>", "<Up>", "j", "k" }) do
	vim.keymap.set({ "n", "v" }, key, function()
		if vim.v.count > max_distance then
			return "m'" .. vim.v.count .. key
		end
		return key
	end, { expr = true })
end
```

Set some bindings to run SQL queries using the `usql` cli program.

```lua

local utils = require("config.utils")
local custom_sql_group = vim.api.nvim_create_augroup("custom_sql", { clear = true })

vim.api.nvim_create_autocmd("filetype", {
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
```

-- vim.lsp.set_log_level 'debug'
-- require('vim.lsp.log').set_format_func(vim.inspect)

local utils = require("config.utils")
vim.g.mapleader = " "
vim.opt.equalprg = "sh"

vim.cmd([[filetype plugin on]])

vim.opt.jumpoptions:append("stack")

vim.opt.colorcolumn:append("100")

-- Sign Column
vim.opt.fillchars:append("foldclose:▾")
vim.opt.fillchars:append("foldopen:▸")
vim.opt.fillchars:append("foldsep: ")
vim.opt.fillchars:append("eob: ")

vim.fn.sign_define({
	{ name = "DiagnosticSignError", text = "⚠", texthl = "DiagnosticError" },
	{ name = "DiagnosticSignWarn", text = "⚠", texthl = "DiagnosticWarn" },
	{ name = "DiagnosticSignInfo", text = "?", texthl = "DiagnosticInfo" },
	{ name = "DiagnosticSignHint", text = "?", texthl = "DiagnosticHint" },
})

------------ Undo file --------------
local undo_dir = vim.fn.stdpath("data") .. "/undofiles"
if vim.fn.isdirectory(undo_dir) == 0 then
	vim.fn.mkdir(undo_dir, "", 448) -- 448 is 700 perm
end
vim.o.undodir = undo_dir
vim.o.undofile = true

------------ Ruler options ----------
vim.o.number = true
vim.o.ruler = true
vim.o.relativenumber = true

------------ Encoding options ----------
vim.o.encoding = "utf-8"
vim.o.fileencodings = "utf-8"
vim.o.bomb = false

------------ Search options ----------
vim.o.hlsearch = true
vim.o.wrapscan = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.infercase = true

------------ Render tab characters ----------
--Unnecessary with indent_blankline plugin
--set list
--set listchars=tab:>\

------------ Tab size config ----------
vim.o.tabstop = 4
vim.o.shiftwidth = 0

------------ Timeout ----------
vim.o.timeout = false
vim.o.ttimeout = false

------------ Fix splitting ----------
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.signcolumn = "yes"

------------ Misc ----------
--This options makes so inotifywait works with files being edited by vim
vim.o.backupcopy = "yes"
--Makes so the matching parenthesis and brackets don't jump when placed
vim.o.matchtime = 0
vim.o.showmatch = true
--Set true terminal colors
vim.o.termguicolors = true
--Prevent windows from changing sizes when a new window is created
vim.o.equalalways = false
--Makes so some plugins work better
vim.o.updatetime = 300

local random_commands_group = vim.api.nvim_create_augroup("RandomCommands", { clear = true })

vim.api.nvim_create_autocmd("filetype", {
	pattern = { "lua" },
	group = random_commands_group,
	callback = function()
		vim.keymap.set("n", "<leader>ff", function()
			vim.cmd([[luafile %]])
		end)
	end,
})

local max_distance = 3

for _, key in pairs({ "<Down>", "<Up>", "j", "k" }) do
	vim.keymap.set({ "n", "v" }, key, function()
		if vim.v.count > max_distance then
			return "m'" .. vim.v.count .. key
		end
		return key
	end, { expr = true })
end

---------------------------------------------------

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

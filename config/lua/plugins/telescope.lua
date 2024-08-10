local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function send_selected_to_qflist_plus_open_it(arg)
	actions.send_selected_to_qflist(arg)
	actions.open_qflist(arg)
end

require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<C-S>"] = send_selected_to_qflist_plus_open_it,
				["<M-Q>"] = false,
				["<M-q>"] = false,
			},
			n = {
				["<C-S>"] = send_selected_to_qflist_plus_open_it,
				["<M-Q>"] = false,
			},
		},
	},
	pickers = {
		git_commits = {
			mappings = {
				i = {
					["<C-z>"] = actions.cycle_previewers_next,
					["<C-x>"] = actions.cycle_previewers_prev,
				},
				n = {
					["z"] = actions.cycle_previewers_next,
					["x"] = actions.cycle_previewers_prev,
				},
			},
		},
		git_bcommits = {
			mappings = {
				i = {
					["<C-z>"] = actions.cycle_previewers_next,
					["<C-x>"] = actions.cycle_previewers_prev,
				},
				n = {
					["z"] = actions.cycle_previewers_next,
					["x"] = actions.cycle_previewers_prev,
				},
			},
		},
	},
	extensions = {},
})

require("config.utils").keymaps({
	{ "<leader>tdd", "<cmd>Telescope diagnostics<cr>",                desc = "Open diagnostics" },
	-- Diagnostics
	{ "<leader>tdd", "<cmd>Telescope diagnostics<cr>",                desc = "Open diagnostics" },
	{ "<leader>tdh", "<cmd>Telescope diagnostics severity=HINT<cr>",  desc = "Open diagnostics for errors" },
	{ "<leader>tdi", "<cmd>Telescope diagnostics severity=INFO<cr>",  desc = "Open diagnostics for errors" },
	{ "<leader>tdw", "<cmd>Telescope diagnostics severity=WARN<cr>",  desc = "Open diagnostics for errors" },
	{ "<leader>tde", "<cmd>Telescope diagnostics severity=ERROR<cr>", desc = "Open diagnostics for errors" },

	-- Notify
	{ "<leader>tn",  ":Telescope notify<CR>",                         desc = "Open notifications history" },
	---------------------- Git --------------------
	{ "<leader>tgb", ":Telescope telescope_git all_branches<CR>",     desc = "Open branch list" },
	{ "<leader>tgd", ":Telescope git_bcommits<CR>",                   desc = "Open git commits for current file" },
	{ "<leader>tgc", ":Telescope git_commits<CR>",                    desc = "Open git commits" },
	{ "<leader>tgs", ":Telescope git_status<CR>",                     desc = "Open git status" },
	{ "<leader>tgf", ":Telescope git_files<CR>",                      desc = "Open git files" },
	-- Default Telescope
	{ "<leader>tt",  ":Telescope<CR>",                                desc = "Open telescope pickers" },
	{ "<leader>twt", ":Telescope live_grep<CR>",                      desc = "Open live grep" },
	{ "<leader>th",  ":Telescope help_tags<CR>",                      desc = "Open help window" },
	{ "<leader>tp",  require("telescope.builtin").resume,             desc = "Resume last picker" },
	{
		"<leader>tr",
		":Telescope lsp_references<CR>",
		noremap = true,
		desc = "Open LSP references",
	},
})

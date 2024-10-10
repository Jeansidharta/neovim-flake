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

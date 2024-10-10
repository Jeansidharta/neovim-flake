local ls = require("luasnip")
local utils = require("config.utils")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local types = require("luasnip.util.types")

ls.config.set_config({
	history = true,
	-- Update more often, :h events for more info.
	updateevents = "TextChanged,TextChangedI",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "choiceNode", "Comment" } },
			},
		},
	},
	-- treesitter-hl has 100, use something higher (default is 200).
	ext_base_prio = 300,
	-- minimal increase in priority.
	ext_prio_increase = 1,
	enable_autosnippets = true,
})

vim.api.nvim_create_autocmd("Filetype", {
	pattern = "markdown",
	callback = function(_ev)
		local project_root = require("config.utils").find_project_root()
		if not project_root then
			-- vim.print("Project root not found")
			return
		end
		-- vim.print("Project root is " .. project_root)

		local database_path = vim.fs.find(function(name)
			return name:match(".sqlite3$")
		end, { path = project_root })[1]

		if not database_path then
			-- vim.print("No database found")
			return
		end

		local available_snipts = ls.available()

		if
			available_snipts.markdown
			and utils.tbl_find(function(snip)
				return snip.name == "`usql"
			end, available_snipts.markdown)
		then
			return
		end

		ls.add_snippets("markdown", {
			s("`usql", {
				t({ "```usql " .. database_path }),
				i(1),
				t({ "", "", "```" }),
			}),
		})
	end,
})

require("luasnip.loaders.from_snipmate").lazy_load()

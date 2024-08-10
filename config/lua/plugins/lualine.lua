local get_hunks = require("gitsigns").get_hunks

local function filesize()
	local file = vim.fn.expand("%:p")
	if file == nil or #file == 0 then
		return ""
	end
	local size = vim.fn.getfsize(file)
	if size <= 0 then
		return ""
	end

	local suffixes = { "B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB" }

	local i = 1
	while size > 1024 and i < #suffixes do
		size = size / 1024
		i = i + 1
	end

	local format = i == 1 and "%d %s" or "%.1f %s"
	return string.format(format, size, suffixes[i])
end

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			{
				"diff",
				colored = true, -- Displays a colored diff status if set to true
				diff_color = {
					-- Same color values as the general color option can be used here.
					added = "DiffAdd",                                  -- Changes the diff's added color
					modified = "DiffChange",                            -- Changes the diff's modified color
					removed = "DiffDelete",                             -- Changes the diff's removed color you
				},
				symbols = { added = "+", modified = "~", removed = "-" }, -- Changes the symbols used by the diff.
				source = function()
					local hunks = get_hunks()

					if hunks == nil then
						return nil
					end

					local added = 0
					local removed = 0
					local modified = 0

					for index, hunk in pairs(hunks) do
						if hunk.type == "add" then
							added = added + 1
						elseif hunk.type == "change" then
							modified = modified + 1
						elseif hunk.type == "delete" then
							removed = removed + 1
						end
					end
					return {
						added = added,
						removed = removed,
						modified = modified,
					}
				end,
			},
			"diagnostics",
			"filename",
			"overseer",
		},
		lualine_x = { { filesize }, "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})

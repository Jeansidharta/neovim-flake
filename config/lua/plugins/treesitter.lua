local install_path = vim.env.TREESITTER_INSTALL_DIR

vim.opt.runtimepath:append(install_path)
require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all"
	ensure_installed = {
		"typescript",
		"rust",
		"lua",
		"bash",
		"diff",
		"fish",
		"git_rebase",
		"gitcommit",
		"gitignore",
		"gitattributes",
		"go",
		"html",
		"json",
		"css",
		"http",
		"javascript",
		"scss",
		"sql",
		"sxhkdrc",
		"terraform",
		"toml",
		"tsx",
		"vim",
		"vue",
		"yaml",
		"yuck",
		"zig",
		"hyprlang",
		"nix",
	},

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	auto_install = false,

	-- List of parsers to ignore installing (for "all")
	ignore_install = {},

	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	parser_install_dir = install_path,

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		disable = {},

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = true,
	},
	indent = {
		enable = true,
	},
})

require("nvim-treesitter").define_modules({
	attach = function(bufnr, lang)
		print("Attached to " .. bufnr .. " as " .. lang)
	end,
	detach = function(bufnr)
		print("Detached from " .. bufnr)
	end,
	is_supported = function(_lang)
		return true
	end,
})

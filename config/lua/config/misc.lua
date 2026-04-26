-- Add filetypes detaction
vim.filetype.add({
	extension = {
		mdx = "markdown",
	},
})

-- Fix nix expandtab
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "nix" },
	callback = function(_)
		vim.bo.expandtab = true
	end,
})

-- Godot auto-start listener
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local port = tonumber(os.getenv("GDScript_Port")) or 6005
		local pipe = "/tmp/nvim-godot-pipe"

		local root_dir = vim.fs.root(0, { "project.godot" })
		if root_dir == nil then
			return
		end
		vim.lsp.start({
			name = "Godot",
			cmd = vim.lsp.rpc.connect("127.0.0.1", port),
			root_dir = root_dir,
			on_init = function(client, init_result)
				vim.api.nvim_command('echo serverstart("' .. pipe .. '")')
			end,
		})
	end,
})

vim.api.nvim_create_user_command("LspLog", function(_)
	local state_path = vim.fn.stdpath("state")
	local log_path = vim.fs.joinpath(state_path, "lsp.log")

	vim.cmd(string.format("edit %s", log_path))
end, {
	desc = "Show LSP log",
})

vim.cmd("packadd nvim.difftool")

local custom_augroup = vim.api.nvim_create_augroup("CustomAugroup", {})
vim.api.nvim_create_autocmd("ColorScheme", {
	group = custom_augroup,
	callback = function()
		vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#ccfff7" })
		vim.api.nvim_set_hl(0, "Directory", { fg = "#00ffd5" })
		vim.api.nvim_set_hl(0, "WarningMsg", { fg = "#ff8000" })
		vim.api.nvim_set_hl(0, "qfWarning", { link = "WarningMsg" })
		vim.api.nvim_set_hl(0, "qfNote", { fg = "#ff66cc" })
		vim.api.nvim_set_hl(0, "qfError", { fg = "#ff0055" })
		vim.api.nvim_set_hl(0, "QuickFixLine", { bg = "#261d26" })

		vim.api.nvim_set_hl(0, "String", { fg = "#15ff00" })
		vim.api.nvim_set_hl(0, "Type", { fg = "#00ffd5" })
		vim.api.nvim_set_hl(0, "@type.builtin", { fg = "#00ffd5" })
		vim.api.nvim_set_hl(0, "Pmenu", {}) -- Clear

		-- SQL has no LSP, so we rely on syntax highlight
		vim.api.nvim_set_hl(0, "@attribute.sql", { fg = "#ff8000" })
		vim.api.nvim_set_hl(0, "@keyword.operator.sql", { fg = "#ff66cc" })
		vim.api.nvim_set_hl(0, "@keyword.sql", { fg = "#ff66cc" })

		local custom_augroup_per_language = vim.api.nvim_create_augroup("CustomAugroupPerLanguage", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = custom_augroup_per_language,
			pattern = { "cs" },
			callback = function()
				-- They look bad with the c# roslyn lsp
				vim.lsp.semantic_tokens.enable(false)
			end
		})
	end,
})

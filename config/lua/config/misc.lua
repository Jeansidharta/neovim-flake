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

	vim.cmd.edit(log_path)
end, {
	desc = "Show LSP log",
})

vim.cmd.packadd("nvim.difftool")

-- Enable inlay-hints automatically if supported
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local bufnr = ev.buf
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then
			return
		end
		if client.server_capabilities.inlayHintProvider then
			-- This actually sucks to be enabled by default
			vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
		end
		if client.server_capabilities.codeLensProvider then
			-- This actually sucks to be enabled by default
			vim.lsp.codelens.enable(false, { bufnr = bufnr })
		end
		if client.server_capabilities.inlineCompletionProvider then
			vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
		end
	end,
})

local custom_augroup = vim.api.nvim_create_augroup("CustomAugroup", {})
vim.api.nvim_create_autocmd("ColorScheme", {
	group = custom_augroup,
	callback = function()
		local colors = {
			teal = "#00ffd5",
			ligh_blue = "#ccfff7",
			orange = "#ff8000",
			pink = "#ff66cc",
			bubblegum = "#ff0055",
			dark_brown = "#660000",
			gray = "#261d26",
			green = "#15ff00",
			yellow = "#e6e600",
		};
		local semantic = {
			type = colors.teal,
			hint = colors.ligh_blue,
			warning = colors.orange,
			highlight = colors.pink,
			error = colors.bubblegum,
			soft_error_bg = colors.dark_brown,
			extra_bg = colors.dark_brown,
			soft_highlight = colors.gray,
			strings = colors.green,

			keyword = colors.pink,
			operators = colors.orange,
			variable = colors.green,
			method = colors.pink,

			snippet = colors.yellow,
		}

		vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = semantic.hint })
		vim.api.nvim_set_hl(0, "Directory", { fg = semantic.type })
		vim.api.nvim_set_hl(0, "WarningMsg", { fg = semantic.warning })
		vim.api.nvim_set_hl(0, "qfWarning", { link = "WarningMsg" })
		vim.api.nvim_set_hl(0, "qfNote", { fg = semantic.highlight })
		vim.api.nvim_set_hl(0, "qfError", { fg = semantic.error })
		vim.api.nvim_set_hl(0, "SpellBad", { bg = semantic.soft_error_bg })
		vim.api.nvim_set_hl(0, "QuickFixLine", { bg = semantic.soft_highlight })

		vim.api.nvim_set_hl(0, "String", { fg = semantic.strings })
		vim.api.nvim_set_hl(0, "Type", { fg = semantic.type })
		vim.api.nvim_set_hl(0, "Pmenu", {}) -- Clear
		vim.api.nvim_set_hl(0, "PMenuExtra", {}) -- Clear
		vim.api.nvim_set_hl(0, "PMenuKind", { fg = semantic.hint })
		vim.api.nvim_set_hl(0, "PMenuSel", { bg = semantic.soft_highlight })
		vim.api.nvim_set_hl(0, "@type.builtin", { fg = semantic.type })
		vim.api.nvim_set_hl(0, "@keyword", { fg = semantic.keyword })
		vim.api.nvim_set_hl(0, "@operator", { fg = semantic.operators })

		vim.api.nvim_set_hl(0, "@lsp.typemod.keyword.documentation", { fg = semantic.highlight })
		vim.api.nvim_set_hl(0, "@lsp.mod.documentation", { link = "@lsp.typemod.keyword.documentation" })
		-- vim.api.nvim_set_hl(0, "@comment.documentation", { link = "@lsp.typemod.keyword.documentation" })

		vim.api.nvim_set_hl(0, "BlinkCmpLabel", { fg = semantic.hint })
		-- Blink.cmp icons highlighting
		-- vim.api.nvim_set_hl(0, "BlinkCmpKindText", { fg = semantic.hint })
		vim.api.nvim_set_hl(0, "BlinkCmpKindMethod", { fg = semantic.method })
		vim.api.nvim_set_hl(0, "BlinkCmpKindFunction", { fg = semantic.method })
		vim.api.nvim_set_hl(0, "BlinkCmpKindConstructor", { fg = semantic.method })
		vim.api.nvim_set_hl(0, "BlinkCmpKindField", { fg = semantic.variable })
		vim.api.nvim_set_hl(0, "BlinkCmpKindVariable", { fg = semantic.variable })
		vim.api.nvim_set_hl(0, "BlinkCmpKindClass", { fg = semantic.type })
		vim.api.nvim_set_hl(0, "BlinkCmpKindInterface", { fg = semantic.type })
		vim.api.nvim_set_hl(0, "BlinkCmpKindModule", { fg = semantic.highlight })
		vim.api.nvim_set_hl(0, "BlinkCmpKindProperty", { fg = semantic.variable })
		vim.api.nvim_set_hl(0, "BlinkCmpKindUnit", { fg = semantic.type })
		vim.api.nvim_set_hl(0, "BlinkCmpKindValue", { fg = semantic.variable })
		vim.api.nvim_set_hl(0, "BlinkCmpKindEnum", { fg = semantic.type })
		vim.api.nvim_set_hl(0, "BlinkCmpKindKeyword", { fg = semantic.keyword })
		vim.api.nvim_set_hl(0, "BlinkCmpKindSnippet", { fg = semantic.snippet })
		vim.api.nvim_set_hl(0, "BlinkCmpKindColor", { fg = semantic.variable })
		vim.api.nvim_set_hl(0, "BlinkCmpKindFile", { fg = semantic.method })
		-- vim.api.nvim_set_hl(0, "BlinkCmpKindReference", { fg = semantic.hint })
		-- vim.api.nvim_set_hl(0, "BlinkCmpKindFolder", { fg = semantic.hint })
		vim.api.nvim_set_hl(0, "BlinkCmpKindEnumMember", { fg = semantic.variable })
		vim.api.nvim_set_hl(0, "BlinkCmpKindConstant", { fg = semantic.variable })
		vim.api.nvim_set_hl(0, "BlinkCmpKindStruct", { fg = semantic.type })
		-- vim.api.nvim_set_hl(0, "BlinkCmpKindEvent", { fg = semantic.hint })
		vim.api.nvim_set_hl(0, "BlinkCmpKindOperator", { fg = semantic.operators })
		vim.api.nvim_set_hl(0, "BlinkCmpKindTypeParameter", { fg = semantic.type })


		local custom_augroup_per_language = vim.api.nvim_create_augroup("CustomAugroupPerLanguage", { clear = true })

		local forType = function(type_pattern, f)
			vim.api.nvim_create_autocmd("FileType", {
				group = custom_augroup_per_language,
				pattern = type(type_pattern) == "table" and type_pattern or { type_pattern },
				callback = f
			})
		end

		forType("cs", function()
			-- They look bad with the c# roslyn lsp
			vim.lsp.semantic_tokens.enable(false)
		end)
		forType("sql", function()
			-- SQL has no LSP, so we rely on syntax highlight
			vim.api.nvim_set_hl(0, "@attribute.sql", { fg = semantic.operators })
			vim.api.nvim_set_hl(0, "@keyword.operator.sql", { fg = semantic.keyword })
			vim.api.nvim_set_hl(0, "@keyword.sql", { fg = semantic.keyword })
		end)
	end,
})

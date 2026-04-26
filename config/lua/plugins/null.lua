local nls = require("null-ls")

nls.setup({
	debounce = 150,
	-- save_after_format = false,
	on_attach = function(client)
		-- vim.keymap.set("n", "<S-Tab>", function()
		-- 	vim.lsp.buf.format({ id = client.id })
		-- end, { noremap = true, desc = "Format buffer" })
	end,
	should_attach = function(bufnr)
		local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
		return filetype ~= "text-image"
	end,
	sources = {
		nls.builtins.code_actions.gitsigns,
		-- Lua
		nls.builtins.formatting.gleam_format,
		nls.builtins.formatting.gofmt.with({
			condition = function()
				-- Only use gofmt if gofumpt does not exist.
				return vim.fn.executable("gofumpt") == 0
			end,
		}),
		nls.builtins.formatting.gofumpt,
		nls.builtins.formatting.goimports,
		nls.builtins.formatting.nixfmt,
		nls.builtins.formatting.opentofu_fmt,
		nls.builtins.diagnostics.selene.with({
			condition = function(utils)
				return utils.root_has_file({ "selene.toml" })
			end,
		}),
		nls.builtins.formatting.prettierd.with({
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"css",
				"svelte",
				"scss",
				"less",
				"html",
				"json",
				"jsonc",
				"yaml",
				"markdown",
				"markdown.mdx",
				"graphql",
				"handlebars",
				"astro",
			},
		}),
	},
})

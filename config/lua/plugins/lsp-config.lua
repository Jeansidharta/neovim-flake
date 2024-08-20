vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local bufnr = ev.buf
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then
			return
		end
		if client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end
	end,
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr) end

require("lspconfig").lua_ls.setup({})
require("lspconfig").bashls.setup({})
require("lspconfig").cssls.setup({})
require("lspconfig").eslint.setup({})
require("lspconfig").gleam.setup({})
require("lspconfig").html.setup({})
require("lspconfig").nginx_language_server.setup({})
require("lspconfig").sqls.setup({})
require("lspconfig").jsonls.setup({})
require("lspconfig").marksman.setup({})
require("lspconfig").svelte.setup({})
require("lspconfig").terraformls.setup({})
require("lspconfig").zk.setup({})
require("lspconfig").nil_ls.setup({})
require("lspconfig").rust_analyzer.setup({})
require("lspconfig").zls.setup({})

require("lspconfig").openscad_ls.setup({
	cmd = {
		"/home/sidharta/projects/git/openscad-LSP/target/release/openscad-lsp",
		"--stdio",
		"--fmt-exe",
	},
})

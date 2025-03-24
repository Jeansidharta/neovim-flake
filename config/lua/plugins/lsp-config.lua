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

local capabilities = require("blink.cmp").get_lsp_capabilities()

require("lspconfig").ts_ls.setup({ capabilities = capabilities })
require("lspconfig").lua_ls.setup({ capabilities = capabilities })
require("lspconfig").bashls.setup({ capabilities = capabilities })
require("lspconfig").cssls.setup({ capabilities = capabilities })
require("lspconfig").eslint.setup({ capabilities = capabilities })
require("lspconfig").gleam.setup({ capabilities = capabilities })
require("lspconfig").html.setup({ capabilities = capabilities })
require("lspconfig").nginx_language_server.setup({ capabilities = capabilities })
require("lspconfig").sqls.setup({ capabilities = capabilities })
require("lspconfig").jsonls.setup({ capabilities = capabilities })
require("lspconfig").marksman.setup({ capabilities = capabilities })
require("lspconfig").svelte.setup({ capabilities = capabilities })
require("lspconfig").terraformls.setup({ capabilities = capabilities })
require("lspconfig").zk.setup({ capabilities = capabilities })
require("lspconfig").nil_ls.setup({ capabilities = capabilities })
require("lspconfig").rust_analyzer.setup({ capabilities = capabilities })
require("lspconfig").emmet_language_server.setup({})
require("lspconfig").astro.setup({ capabilities = capabilities })
require("lspconfig").zls.setup({
	capabilities = capabilities,
	settings = {
		zls = {
			enable_build_on_save = true,
			enable_autofix = true,
		},
	},
})

require("lspconfig").openscad_ls.setup({
	capabilities = capabilities,
	cmd = {
		"openscad-lsp",
		"--stdio",
	},
})

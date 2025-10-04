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

vim.lsp.enable("ts_ls")
vim.lsp.config("lua_ls", {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using (most
				-- likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
				-- Or pull in all of 'runtimepath'.
				-- NOTE: this is a lot slower and will cause issues when working on
				-- your own configuration.
				-- See https://github.com/neovim/nvim-lspconfig/issues/3189
				-- library = {
				--   vim.api.nvim_get_runtime_file('', true),
				-- }
			},
		})
	end,
	settings = {
		Lua = {},
	},
})
vim.lsp.enable("lua_ls")
vim.lsp.enable("bashls")
vim.lsp.enable("cssls")
vim.lsp.enable("eslint")
vim.lsp.enable("gleam")
vim.lsp.enable("html")
vim.lsp.enable("nginx_language_server")
vim.lsp.enable("sqls")
vim.lsp.enable("jsonls")
vim.lsp.enable("marksman")
vim.lsp.enable("svelte")
vim.lsp.enable("terraformls")
vim.lsp.enable("zk")
vim.lsp.enable("nil_ls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("emmet_language_server")
vim.lsp.enable("astro")
vim.lsp.config("qmlls", {
	cmd = { "qmlls", "-E" },
})
vim.lsp.enable("qmlls")
vim.lsp.config("zls", {
	settings = {
		zls = {
			enable_build_on_save = true,
		},
	},
})
vim.lsp.enable("zls")

vim.lsp.enable("openscad_ls")

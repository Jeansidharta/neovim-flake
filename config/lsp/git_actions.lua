---@alias RequestHandler fun(
---  params: table<string, any>,
---  callback: fun(err: lsp.ResponseError?, result: any),
---  notify_reply_callback: fun(message_id: number))

---@type table<vim.lsp.protocol.Method, RequestHandler>
local handlers = {
	[vim.lsp.protocol.Methods.textDocument_codeLens] = function(params, callback)
		callback(nil, { {
			range = { start = { line = 1, character = 1 }, ["end"] = { line = 1, character = 10 }, },
			command = {
				title = "Hello :)",
				command = "hello",
			}
		} })
	end,
	["textDocument/hover"] = function(params, callback)
		callback(nil, { contents = { kind = "markdown", value = "Batata com comate :)", } })
	end,

	initialize = function(params, callback, notify_reply_callback)
		callback(nil, {
			capabilities = {
				hoverProvider = true,
				codeLensProvider = { resolveProvider = false },
			},
			serverInfo = {
				name = "git_actions",
				version = "0.0.1",
			}
		})
	end
}

return {
	name = "git_actions",
	filetypes = { "markdown" },
	cmd = function()
		return {
			request = function(method, params, callback, notify_reply_callback)
				vim.print(method)
				if handlers[method] then
					handlers[method](params, callback, notify_reply_callback)
				end
			end,
			notify = function() end,
			is_closing = function() end,
			terminate = function() end,
		}
	end
}

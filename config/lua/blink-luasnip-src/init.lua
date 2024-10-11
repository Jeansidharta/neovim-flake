local blink = require("blink.cmp")
local M = {}

M.snip_cache = {}

function M.new(_)
	return setmetatable({}, { __index = M })
end

function M:get_completions(_, callback)
	local filetypes = require("luasnip.util.util").get_snippet_filetypes()
	local items = {}

	for i = 1, #filetypes do
		local ft = filetypes[i]
		if not M.snip_cache[ft] then
			local ft_items = {}
			local ft_table = require("luasnip").get_snippets(ft, { type = "snippets" })
			local iter_tab
			local auto_table = require("luasnip").get_snippets(ft, { type = "autosnippets" })
			iter_tab = { { ft_table, false }, { auto_table, true } }
			for _, ele in ipairs(iter_tab) do
				local tab, auto = unpack(ele)
				for j, snip in pairs(tab) do
					if not snip.hidden then
						ft_items[#ft_items + 1] = {
							blink.sources.buffer,
							label = snip.trigger,
							kind = require("blink.cmp.types").CompletionItemKind.Snippet,
							insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
							data = {
								filetype = ft,
								snip_id = snip.id,
								show_condition = snip.show_condition,
								auto = auto,
							},
						}
					end
				end
			end
			M.snip_cache[ft] = ft_items
		end
		vim.list_extend(items, M.snip_cache[ft])
	end

	callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = items })
end

function M:resolve(item, callback)
	local snip = require("luasnip").get_id_snippet(item.data.snip_id)
	local documentation = vim.trim(table.concat(snip.description or { "" }, "\n"))
	if documentation ~= "" then
		item.documentation = {
			kind = "markdown",
			value = documentation,
		}
	end
	item.insertText = snip.docstring
	callback(item)
end

return M

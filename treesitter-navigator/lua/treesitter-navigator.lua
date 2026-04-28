---@alias TextPos [number, number]

---@class TreesitterNavigator
local M = {}
M.__index = M

---@return TSNode | nil
local function root_node()
	local root = vim.treesitter.get_node({ pos = { 0, 0 } })

	if root == nil then
		return nil
	end

	while root:parent() ~= nil do
		local parent = root:parent()
		---@cast parent TSNode Remove nil
		root = parent
	end
	return root
end

---@param root TSNode
---@return TSNode | nil
local function node_in_visual_selection(root)
	local start_pos = { unpack(vim.fn.getpos("v"), 2, 3) }
	local end_pos = { unpack(vim.fn.getpos("."), 2, 3) }
	start_pos[1] = start_pos[1] - 1
	start_pos[2] = start_pos[2] - 1
	end_pos[1] = end_pos[1] - 1
	end_pos[2] = end_pos[2] - 1

	if start_pos[1] > end_pos[1] or (start_pos[1] == end_pos[1] and start_pos[2] > end_pos[2]) then
		local buf = start_pos
		start_pos = end_pos
		end_pos = buf
	end

	local node = root:descendant_for_range(start_pos[1], start_pos[2], end_pos[1], end_pos[2])
	if node == nil then
		return nil
	end

	-- Find the highest parent that has the same range as our node
	-- This is to prevent cases where the node is the only child of a parent,
	-- and therefore can't be swapped with a neighbour
	local parent = node:parent()
	while parent ~= nil and vim.deep_equal({ parent:range() }, { node:range() }) do
		node = parent
		parent = node:parent()
	end

	return node
end

local TextRange = (function()
	---@class TextRange
	---@field text string[]
	---@field begin TextPos
	---@field finish TextPos
	local M = {}
	M.__index = M

	---@param text string[]
	---@param begin TextPos
	---@param finish TextPos
	function M.new(text, begin, finish)
		return setmetatable({ text = text, begin = begin, finish = finish }, M)
	end

	---Uses a Treesitter Node
	---@param node TSNode
	function M.from_tsnode(node)
		local bs, be, fs, fe = node:range()
		return M.new(vim.api.nvim_buf_get_text(0, bs, be, fs, fe, {}), { bs, be }, { fs, fe })
	end

	---Whether this diff will apply before the other diff
	---@param other TextRange
	---@return boolean
	function M:is_before(other)
		return self.begin[1] < other.begin[1] or (self.begin[1] == other.begin[1] and self.begin[2] < other.begin[2])
	end

	---@param new_text string[]
	---@return TextPos
	function M:replace_text(new_text)
		local old_finish = { unpack(self.finish) }
		vim.api.nvim_buf_set_text(0, self.begin[1], self.begin[2], self.finish[1], self.finish[2], new_text)
		self.finish[1] = self.begin[1] + #new_text - 1
		if self.finish[1] ~= self.begin[1] then
			self.finish[2] = #(new_text[#new_text])
		else
			self.finish[2] = self.begin[2] + #(new_text[#new_text])
		end
		return { self.finish[1] - old_finish[1], self.finish[2] - old_finish[2] }
	end

	function M:set_as_selection()
		-- Go to normal mode
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, false, true), 'n', true)
		vim.schedule(function()
			vim.fn.setpos("'<", { 0, self.begin[1] + 1, self.begin[2] + 1, 0 })
			vim.fn.setpos("'>", { 0, self.finish[1] + 1, self.finish[2], 0 })
			-- Go to visual mode
			vim.api.nvim_feedkeys("gv", "n", true)
		end)
	end

	return M
end)()

---@param text_from TextRange
---@param text_to TextRange
local function swap_text_ranges(text_from, text_to)
	local first = text_from
	local last = text_to
	if last:is_before(first) then
		first, last = last, first
	end

	last:replace_text(first.text)
	local diff = first:replace_text(last.text)
	last.begin[1] = last.begin[1] + diff[1]
	last.finish[1] = last.finish[1] + diff[1]
	if last.begin[1] == first.finish[1] then
		last.begin[2] = last.begin[2] + diff[2]
		last.finish[2] = last.finish[2] + diff[2]
	end

	text_to:set_as_selection()
end

function M.swap_next()
	local root = root_node()
	assert(root ~= nil, "Failed to determine root node")

	local cur = node_in_visual_selection(root)
	assert(cur ~= nil, "Failed to determine current node")

	local next = cur:next_named_sibling()
	if next == nil then
		local parent = cur:parent()
		assert(parent ~= nil, "Failed to determine parent node of current node")
		next = parent:named_child(0)
		assert(next ~= nil, "Failed to determine next node")
	end

	swap_text_ranges(TextRange.from_tsnode(cur), TextRange.from_tsnode(next))
end

function M.swap_prev()
	local root = root_node()
	assert(root ~= nil, "Failed to determine root node")

	local cur = node_in_visual_selection(root)
	assert(cur ~= nil, "Failed to determine current node")

	local previous = cur:prev_named_sibling()
	if previous == nil then
		local parent = cur:parent()
		assert(parent ~= nil, "Failed to determine parent node of current node")
		previous = parent:named_child(parent:named_child_count() - 1)
		assert(previous ~= nil, "Failed to determine previous node")
	end

	swap_text_ranges(TextRange.from_tsnode(cur), TextRange.from_tsnode(previous))
end

function M.setup(opts)
	local opts = opts or {}
	vim.api.nvim_create_user_command("TSNavNext", M.swap_next, {})
	vim.api.nvim_create_user_command("TSNavPrev", M.swap_prev, {})
end

return M

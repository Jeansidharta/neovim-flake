---@alias TextPos [number, number]

---@class TreesitterNavigator
local M = {}
M.__index = M

local function to_normal_mode()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, false, true), 'n', true)
end

local function to_visual_mode()
	vim.api.nvim_feedkeys("gv", "n", true)
end

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
		to_normal_mode()
		vim.schedule(function()
			vim.fn.setpos("'<", { 0, self.begin[1] + 1, self.begin[2] + 1, 0 })
			vim.fn.setpos("'>", { 0, self.finish[1] + 1, self.finish[2], 0 })
			to_visual_mode()
		end)
	end

	---@param other TextRange
	function M:cmp_text(other)
		for i, text in pairs(self.text) do
			if i > #other.text or text < other.text[i] then
				return -1
			elseif text > other.text[i] then
				return 1
			end
		end
		return 0
	end

	function M:gt_text(other)
		return self:cmp_text(other) == 1
	end

	function M:lt_text(other)
		return self:cmp_text(other) == -1
	end

	---Transforms the text property, which is a list of lines, into a single string
	---Useful for debugging with `vim.print(range:text_to_string())`
	---@return string
	function M:text_to_string()
		local res = self.text[1] or ""
		for i = 2, #self.text, 1 do
			res = res .. "\n" .. self.text[i]
		end
		return res
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

	local cur_range = TextRange.from_tsnode(cur)
	local next_range = TextRange.from_tsnode(next)
	swap_text_ranges(cur_range, next_range)
	next_range:set_as_selection()
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

	local cur_range = TextRange.from_tsnode(cur)
	local previous_range = TextRange.from_tsnode(previous)
	swap_text_ranges(cur_range, previous_range)
	previous_range:set_as_selection()
end

---@param sort_func fun(a: TextRange, b: TextRange): boolean
function M.sort(sort_func)
	local root = root_node()
	assert(root ~= nil, "Failed to determine root node")

	local cur = node_in_visual_selection(root)
	assert(cur ~= nil, "Failed to determine current node")

	local children = cur:named_children()
	while #children == 1 do
		children = children[1]:named_children()
	end
	---@type TextRange[]
	local children_range = vim.tbl_map(TextRange.from_tsnode, children)

	---@type TextRange[] Shallow copy
	local sorted_children_range = { unpack(children_range) }
	table.sort(sorted_children_range, sort_func)

	for i in ipairs(children_range) do
		-- Invert i, so we iterate from last to first
		-- Iterating backwards is important so our text changes don't interfere with each other
		i = #children_range - i + 1

		if children_range[i] ~= sorted_children_range[i] then
			children_range[i]:replace_text(sorted_children_range[i].text)
		end
	end

	-- Reset selection, in case it was lost during sorting
	TextRange.from_tsnode(cur):set_as_selection()
end

function M.create_user_commands()
	vim.api.nvim_create_user_command("TSNavNext", M.swap_next, {})
	vim.api.nvim_create_user_command("TSNavPrev", M.swap_prev, {})

	vim.api.nvim_create_user_command("TSNavSort", function()
		M.sort(TextRange.lt_text)
	end, {})
	vim.api.nvim_create_user_command("TSNavSortRev", function()
		M.sort(TextRange.gt_text)
	end, {})
end

M.create_user_commands()

return M

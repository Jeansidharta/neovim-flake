local colors = {
	none = "NONE",

	gray = "#333366",
	light_gray = "#333366",
	dark_gray = "#202040",

	red = "#ff0055",
	dark_red = "#d90048",

	green = "#15ff00",
	dark_green = "#10bf00",

	orange = "#ff8000",
	dark_orange = "#bf6000",
	darker_orange = "#804000",

	blue = "#0061ff",
	dark_blue = "#0049bf",

	pink = "#ff66cc",
	dark_pink = "#bf4d99",

	cyan = "#00ffd5",
	dark_cyan = "#00bf9f",

	white = "#ffffff",
	dark_white = "#bfbfbf",
	darker_white = "#808080",
	black = "#0d0d1a",
}
colors.fg = colors.white
colors.fg_highlight = colors.light_graY
colors.bg = colors.dark_gray
colors.bg_highlight = colors.gray

-- Purples
-- purple = "#e135ff", -- Main purple from VSCode
-- purple_dark = "#9580ff", -- VSCode comment/muted purple
-- purple_muted = "#9580ff", -- VSCode comment/muted purple

-- Cyans
-- cyan = "#80ffea", -- Main cyan from VSCode
-- cyan_bright = "#5fffff", -- Brighter cyan
-- cyan_light = "#9ffcf9", -- Lighter cyan

-- Greens
-- green = "#50fa7b", -- VSCode green (terminal.ansiGreen)
-- green_light = "#50fa7b", -- Keep consistent
-- green_bright = "#50fa7b", -- VSCode green

-- Blues
-- blue = "#82AAFF", -- VSCode blue
-- blue_bright = "#82b1ff", -- VSCode bright blue
-- blue_light = "#82AAFF", -- Keep consistent
-- blue_gray = "#6272a4", -- VSCode comment/gray

-- Pinks/Magentas
-- pink = "#ff00ff", -- Pure magenta from VSCode
-- pink_bright = "#ff69ff", -- Bright variant
-- pink_soft = "#ff99ff", -- VSCode string color

-- Others
-- coral = "#ff6ac1", -- VSCode orange/coral
-- red = "#ff6363", -- VSCode error red
-- red_dark = "#ff6363", -- Keep consistent
-- red_error = "#ff6363", -- VSCode error
-- orange = "#ff6ac1", -- VSCode number/constant color
-- yellow = "#f1fa8c", -- VSCode class/type color
-- yellow_bright = "#ffffa5", -- VSCode bright yellow (terminal)
-- yellow_light = "#ffffcc", -- Light yellow
-- }

local semantic = {
	-- Syntax (consistent across all languages)
	keyword = colors.cyan,
	variable = colors.pink,
	variable_builtin = colors.cyan,
	string = colors.orange,
	number = colors.orange,
	boolean = colors.orange,
	constant = colors.orange,
	func = colors.pink,
	["function"] = colors.pink,
	function_builtin = colors.cyan,
	func_call = colors.blue,
	method = colors.pink,
	class = colors.pink,
	type = colors.pink,
	type_builtin = colors.cyan,
	operator = colors.white,
	comment = colors.darker_white,
	punctuation = colors.darker_white,
	bracket = nil,
	label = nil,
	tag = nil,
	attribute = colors.pink,
	property = colors.pink,
	parameter = colors.pink,

	-- Special syntax elements
	namespace = nil,
	decorator = nil,
	annotation = nil,
	preprocessor = nil,
	regex = colors.cyan_bright,
	escape = colors.coral,
	symbol = colors.cyan,
	field = colors.cyan_bright,

	-- UI Elements
	-- border = colors.cyan_bright,
	-- border_alt = colors.purple,
	-- cursor_line = colors.bg_highlight,
	-- line_number = colors.gray,
	-- line_number_active = colors.fg_light,
	-- indent_guide = colors.bg_highlight,
	-- indent_guide_active = colors.purple_muted,
	-- fold = colors.purple_muted,

	-- Selection and Search
	-- selection = colors.selection,
	-- selection_inactive = colors.selection_inactive,
	-- search = colors.yellow,
	-- search_current = colors.coral,
	-- match = colors.pink,

	-- Diagnostics (consistent everywhere)
	-- diag_error = colors.error,
	-- diag_warning = colors.warning,
	-- diag_info = colors.info,
	-- diag_hint = colors.hint,
	-- diag_ok = colors.green_bright,

	-- Diff (for all diff views)
	diff_add = colors.fg,
	diff_change = colors.fg,
	diff_delete = colors.fg,
	diff_add_bg = colors.dark_green,
	diff_change_bg = colors.dark_yellow,
	diff_delete_bg = colors.dark_red,
	diff_text = colors.diff_text,

	-- Git
	-- git_add = colors.git_add,
	-- git_change = colors.git_change,
	-- git_delete = colors.git_delete,
	-- git_ignore = colors.gray,
	-- git_untracked = colors.yellow,

	-- Status indicators
	-- info = colors.info,
	-- success = colors.green_bright,
	-- warning = colors.warning,
	-- error = colors.error,
	-- hint = colors.hint,

	-- Special highlights
	-- todo = colors.yellow,
	-- note = colors.info,
	-- hack = colors.warning,
	-- fixme = colors.error,
}

--- @type table<string, vim.api.keyset.highlight>
local highlights = {
	-- Editor highlights
	Normal = { fg = colors.fg, bg = colors.none },
	NormalFloat = { fg = colors.fg, bg = colors.none },
	NormalNC = { link = "Normal" },
	Cursor = { fg = colors.bg, bg = colors.fg },
	CursorIM = { link = "Cursor" },
	CursorLine = { bg = colors.bg_highlight },
	CursorLineNr = { fg = colors.fg_light, bg = colors.bg_highlight, bold = true },
	CursorColumn = { link = "CursorLine" },
	ColorColumn = { bg = colors.bg_highlight },
	LineNr = { fg = colors.gray },
	VertSplit = { fg = colors.bg_highlight },
	WinSeparator = { fg = colors.bg_highlight },
	FloatBorder = { fg = semantic.border, bg = colors.none },
	FloatTitle = { fg = colors.pink, bg = colors.none, bold = true },
	WinBar = { fg = colors.pink_bright },
	WinBarNC = { fg = colors.purple_muted },
	SignColumn = { fg = colors.fg, bg = colors.none },
	Folded = { fg = colors.gray, bg = colors.bg_highlight },
	FoldColumn = { fg = colors.gray },
	EndOfBuffer = { fg = colors.bg },

	-- Statusline
	StatusLine = { fg = colors.fg_light, bg = colors.bg_highlight },
	StatusLineNC = { fg = colors.gray, bg = colors.bg_highlight },

	-- Pmenu
	Pmenu = { fg = colors.fg, bg = colors.bg_highlight },
	PmenuSel = { fg = colors.bg, bg = colors.purple },
	PmenuSbar = { bg = colors.bg_highlight },
	PmenuThumb = { bg = colors.gray },
	PmenuExtra = { fg = colors.gray },
	PmenuExtraSel = { fg = colors.purple_muted },

	-- Tabs
	TabLine = { fg = colors.gray, bg = colors.bg_highlight },
	TabLineFill = { bg = colors.bg_highlight },
	TabLineSel = { fg = colors.fg_light, bg = colors.bg },

	-- Search & Selection
	Search = { fg = colors.bg, bg = colors.yellow },
	IncSearch = { fg = colors.bg, bg = colors.coral },
	CurSearch = { fg = colors.bg, bg = colors.pink },
	Visual = { bg = colors.selection },
	VisualNOS = { bg = colors.selection },
	Selection = { bg = colors.selection },
	MatchParen = { fg = colors.pink, bold = true },

	-- Misc
	Directory = { fg = colors.blue },
	NonText = { fg = colors.gray },
	SpecialKey = { fg = colors.gray },
	Title = { fg = colors.blue, bold = true },
	Conceal = { fg = colors.gray },
	Question = { fg = colors.green },
	MoreMsg = { fg = colors.green },
	WarningMsg = { fg = colors.warning },
	ErrorMsg = { fg = colors.error },
	WildMenu = { fg = colors.bg, bg = colors.purple },
	ModeMsg = { fg = colors.fg, bold = true },
	Whitespace = { fg = colors.gray },
	TermCursor = { fg = colors.bg, bg = colors.pink },
	TermCursorNC = { fg = colors.bg, bg = colors.purple_muted },

	-- Diff
	DiffAdd = { bg = colors.diff_add },
	DiffChange = { bg = colors.diff_change },
	DiffDelete = { bg = colors.diff_delete },
	DiffText = { bg = colors.diff_text },
	diffAdded = { fg = colors.git_add },
	diffRemoved = { fg = colors.git_delete },
	diffChanged = { fg = colors.git_change },

	-- Spell
	SpellBad = { undercurl = true, sp = colors.error },
	SpellCap = { undercurl = true, sp = colors.warning },
	SpellLocal = { undercurl = true, sp = colors.info },
	SpellRare = { undercurl = true, sp = colors.hint },

	-- Syntax highlights
	Comment = { fg = semantic.comment, italic = true },
	SpecialComment = { fg = colors.purple_muted, italic = true, bold = true },
	Constant = { fg = semantic.constant },
	String = { fg = semantic.string, italic = true },
	Character = { fg = colors.cyan_bright },
	Number = { fg = semantic.number },
	Boolean = { fg = semantic.boolean },
	Float = { fg = semantic.number },

	Identifier = { fg = semantic.variable },
	Function = { fg = semantic.func, bold = true },

	Statement = { fg = semantic.keyword },
	Conditional = { fg = semantic.keyword },
	Repeat = { fg = semantic.keyword },
	Label = { fg = semantic.label },
	Operator = { fg = semantic.operator },
	Keyword = { fg = semantic.keyword },
	Exception = { fg = colors.purple },

	PreProc = { fg = colors.pink_bright },
	Include = { fg = colors.purple },
	Define = { fg = colors.pink_bright },
	Macro = { fg = colors.purple },
	PreCondit = { fg = colors.pink_bright },

	Type = { fg = semantic.type },
	StorageClass = { fg = colors.yellow },
	Structure = { fg = colors.yellow },
	Typedef = { fg = colors.yellow },

	Special = { fg = colors.pink_bright },
	SpecialChar = { fg = colors.coral },
	Tag = { fg = colors.pink, bold = true },
	Delimiter = { fg = colors.fg_dark },
	Debug = { fg = colors.red },

	Underlined = { underline = true },
	Bold = { bold = true },
	Italic = { italic = true },
	Ignore = { fg = colors.gray },
	Error = { fg = colors.error },
	Todo = { fg = colors.bg, bg = colors.pink, bold = true },

	-- Additional vim syntax groups
	qfLineNr = { fg = colors.yellow },
	qfFileName = { fg = colors.cyan_bright },
	htmlH1 = { fg = colors.pink, bold = true },
	htmlH2 = { fg = colors.cyan_bright, bold = true },
	mkdCodeDelimiter = { bg = colors.bg, fg = colors.fg },
	mkdCodeStart = { fg = colors.pink, bold = true },
	mkdCodeEnd = { fg = colors.pink, bold = true },

	-- Health check
	healthError = { fg = colors.red },
	healthSuccess = { fg = colors.green_bright },
	healthWarning = { fg = colors.yellow },

	-- Illuminate
	illuminatedWord = { bg = colors.bg_highlight },
	illuminatedCurWord = { bg = colors.bg_highlight },

	-- Rainbow delimiters
	rainbow1 = { fg = colors.red },
	rainbow2 = { fg = colors.coral },
	rainbow3 = { fg = colors.yellow },
	rainbow4 = { fg = colors.green },
	rainbow5 = { fg = colors.cyan_bright },
	rainbow6 = { fg = colors.pink },

	["@variable"] = { fg = semantic.variable },
	["@variable.builtin"] = { fg = semantic.variable_builtin },
	["@variable.parameter"] = { fg = semantic.parameter },
	["@variable.member"] = { fg = semantic.property },

	["@constant"] = { fg = semantic.constant },
	["@constant.builtin"] = { fg = semantic.function_builtin },
	["@constant.macro"] = { fg = semantic.function_builtin },

	["@module"] = { fg = semantic.namespace },
	["@module.builtin"] = { fg = semantic.namespace },
	["@label"] = { fg = semantic.label },

	-- Literals
	["@string"] = { fg = semantic.string },
	["@string.documentation"] = { fg = semantic.string },
	["@string.regexp"] = { fg = semantic.string },
	["@string.escape"] = { fg = colors.coral },
	["@string.special"] = { fg = colors.coral },
	["@string.special.symbol"] = { fg = colors.cyan },
	["@string.plain"] = { fg = colors.pink_bright }, -- Plain strings without quotes
	["@string.special.path"] = { fg = colors.cyan },
	["@string.special.url"] = { fg = colors.cyan, underline = true },

	["@character"] = { fg = colors.string },
	["@character.special"] = { fg = colors.coral },

	["@boolean"] = { fg = semantic.boolean },
	["@number"] = { fg = semantic.number },
	["@number.float"] = { fg = semantic.number },

	-- Types
	["@type"] = { fg = semantic.type },
	["@type.builtin"] = { fg = semantic.type },
	["@type.definition"] = { fg = semantic.type },
	["@type.qualifier"] = { fg = colors.purple },

	["@attribute"] = { fg = semantic.attribute },
	["@property"] = { fg = semantic.property }, -- Make properties bright cyan

	-- Functions
	["@function"] = { fg = semantic.func },
	["@function.builtin"] = { fg = semantic.func_call },
	["@function.call"] = { fg = semantic.func_call },
	["@function.macro"] = { fg = colors.purple },
	["@function.method"] = { fg = semantic.method },
	["@function.method.call"] = { fg = semantic.func_call },

	["@constructor"] = { fg = semantic.type },
	["@operator"] = { fg = semantic.operator },

	-- Keywords
	["@keyword"] = { fg = semantic.keyword },
	["@keyword.coroutine"] = { fg = colors.keyword },
	["@keyword.function"] = { fg = colors.purple },
	["@keyword.operator"] = { fg = colors.operator },
	["@keyword.import"] = { fg = colors.purple },
	["@keyword.storage"] = { fg = colors.purple },
	["@keyword.repeat"] = { fg = colors.keyword },
	["@keyword.return"] = { fg = colors.keyword },
	["@keyword.debug"] = { fg = colors.red },
	["@keyword.exception"] = { fg = colors.keyword },
	["@keyword.conditional"] = { fg = colors.keyword },
	["@keyword.conditional.ternary"] = { fg = colors.operator },
	["@keyword.directive"] = { fg = colors.purple },
	["@keyword.directive.define"] = { fg = colors.purple },

	-- Punctuation
	["@punctuation.delimiter"] = { fg = semantic.punctuation },
	["@punctuation.bracket"] = { fg = semantic.bracket },
	["@punctuation.special"] = { fg = semantic.punctuation },

	-- Comments
	["@comment"] = { fg = semantic.comment },
	["@comment.documentation"] = { fg = colors.comment },
	["@comment.error"] = { fg = colors.error },
	["@comment.warning"] = { fg = colors.warning },
	["@comment.todo"] = { fg = colors.bg, bg = colors.yellow },
	["@comment.note"] = { fg = colors.bg, bg = colors.info },

	-- Markup
	["@markup"] = { fg = colors.fg },
	["@markup.strong"] = { bold = true },
	["@markup.italic"] = { italic = true },
	["@markup.strikethrough"] = { strikethrough = true },
	["@markup.underline"] = { underline = true },

	["@markup.heading"] = { fg = colors.pink_bright, bold = true },
	["@markup.heading.1"] = { fg = colors.pink_bright, bold = true, bg = colors.bg_highlight },
	["@markup.heading.2"] = { fg = colors.purple, bold = true },
	["@markup.heading.3"] = { fg = colors.cyan_bright, bold = true },
	["@markup.heading.4"] = { fg = colors.yellow, bold = true },
	["@markup.heading.5"] = { fg = colors.green_bright, bold = true },
	["@markup.heading.6"] = { fg = colors.coral, bold = true },

	["@markup.quote"] = { fg = colors.purple_muted, bg = colors.bg_highlight, italic = true },
	["@markup.math"] = { fg = colors.green_bright },
	["@markup.environment"] = { fg = colors.purple },
	["@markup.link"] = { fg = colors.cyan_bright, underline = true, bold = true },
	["@markup.link.label"] = { fg = colors.pink },
	["@markup.link.url"] = { fg = colors.cyan, underline = true, italic = true },
	["@markup.raw"] = { fg = colors.yellow, bg = colors.bg_highlight },
	["@markup.raw.block"] = { fg = colors.yellow, bg = colors.bg_dark },
	["@markup.list"] = { fg = colors.pink_bright },
	["@markup.list.checked"] = { fg = colors.green_bright, bold = true },
	["@markup.list.unchecked"] = { fg = colors.purple },

	-- Tags (HTML/JSX)
	["@tag"] = { fg = semantic.tag },
	["@tag.attribute"] = { fg = semantic.attribute },
	["@tag.delimiter"] = { fg = colors.cyan_bright },

	-- Diff
	["@diff.plus"] = { fg = colors.git_add },
	["@diff.minus"] = { fg = colors.git_delete },
	["@diff.delta"] = { fg = colors.git_change },

	-- Language specific
	["@lsp.type.namespace"] = { fg = semantic.namespace },
	["@lsp.type.type"] = { fg = semantic.type },
	["@lsp.type.class"] = { fg = semantic.class },
	["@lsp.type.enum"] = { fg = semantic.type },
	["@lsp.type.interface"] = { fg = colors.pink },
	["@lsp.type.path"] = { fg = colors.pink },
	["@lsp.type.struct"] = { fg = semantic.type },
	["@lsp.type.parameter"] = { fg = semantic.parameter },
	["@lsp.type.variable"] = { fg = semantic.variable },
	["@lsp.type.property"] = { fg = semantic.property },
	["@lsp.type.enumMember"] = { fg = semantic.constant },
	["@lsp.type.function"] = { fg = semantic.func },
	["@lsp.type.method"] = { fg = semantic.method },
	["@lsp.type.macro"] = { fg = colors.purple },
	["@lsp.type.decorator"] = { fg = semantic.decorator },

	-- Semantic tokens
	["@lsp.type.boolean"] = { link = "@boolean" },
	["@lsp.type.builtinType"] = { link = "@type.builtin" },
	["@lsp.type.comment"] = { link = "@comment" },
	["@lsp.type.escapeSequence"] = { link = "@string.escape" },
	["@lsp.type.formatSpecifier"] = { link = "@punctuation.special" },
	["@lsp.type.keyword"] = { link = "@keyword" },
	["@lsp.type.number"] = { link = "@number" },
	["@lsp.type.operator"] = { link = "@operator" },
	["@lsp.type.selfKeyword"] = { link = "@variable.builtin" },
	["@lsp.type.typeAlias"] = { link = "@type.definition" },
	["@lsp.type.unresolvedReference"] = { link = "@error" },
	["@lsp.typemod.class.defaultLibrary"] = { link = "@type.builtin" },
	["@lsp.typemod.enum.defaultLibrary"] = { link = "@type.builtin" },
	["@lsp.typemod.enumMember.defaultLibrary"] = { link = "@constant.builtin" },
	["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
	["@lsp.typemod.keyword.async"] = { link = "@keyword.coroutine" },
	["@lsp.typemod.macro.defaultLibrary"] = { link = "@function.builtin" },
	["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" },
	["@lsp.typemod.operator.injected"] = { link = "@operator" },
	["@lsp.typemod.string.injected"] = { link = "@string" },
	["@lsp.typemod.type.defaultLibrary"] = { link = "@type.builtin" },
	["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
	["@lsp.typemod.variable.injected"] = { link = "@variable" },

	-- Git commit specific
	["@comment.warning.gitcommit"] = { fg = colors.yellow },
	["@text.gitcommit"] = { fg = colors.pink_bright },
	["@text.title.gitcommit"] = { fg = colors.pink_bright, bold = true },
	["@keyword.gitcommit"] = { fg = colors.purple },
	["gitcommitSummary"] = { fg = colors.pink_bright, italic = true, bold = true },
	["gitcommitOverflow"] = { fg = colors.red },
	["gitcommitBlank"] = { fg = colors.red },
	["gitcommitFirstLine"] = { fg = colors.pink_bright },
	["gitcommitBranch"] = { fg = colors.purple },
	["gitcommitType"] = { fg = colors.purple, bold = true },
	["gitcommitScope"] = { fg = colors.cyan_bright },
	["gitcommitSubject"] = { fg = colors.pink },
	["gitcommitHeader"] = { fg = colors.purple },
	["gitcommitSelectedType"] = { fg = colors.cyan_bright },
	["gitcommitSelectedFile"] = { fg = colors.pink },
	["gitcommitDiscardedType"] = { fg = colors.red },
	["gitcommitDiscardedFile"] = { fg = colors.red },
	["gitcommitUntrackedFile"] = { fg = colors.yellow },
	["gitcommitOnBranch"] = { fg = colors.purple_muted },
	["gitcommitArrow"] = { fg = colors.cyan },
	["gitcommitFile"] = { fg = colors.pink },
	["gitcommitComment"] = { fg = colors.purple_muted, italic = true },
	["gitcommitText"] = { fg = colors.pink }, -- Make commit message text pink!

	-- Language specific highlights
	-- Bash
	["@function.builtin.bash"] = { fg = colors.red, italic = true },

	-- Java
	["@constant.java"] = { fg = colors.cyan_bright },

	-- CSS
	["@property.css"] = { fg = colors.pink },
	["@property.id.css"] = { fg = colors.cyan_bright },
	["@property.class.css"] = { fg = colors.yellow },
	["@type.css"] = { fg = colors.pink },
	["@type.tag.css"] = { fg = colors.purple },
	["@string.plain.css"] = { fg = colors.coral },
	["@number.css"] = { fg = colors.purple_dark },

	-- TOML
	["@property.toml"] = { fg = colors.cyan_bright },

	-- JSON
	["@label.json"] = { fg = colors.cyan_bright },

	-- Lua
	["@constructor.lua"] = { fg = colors.pink },

	-- TypeScript/TSX
	["@property.typescript"] = { fg = colors.pink },
	["@constructor.typescript"] = { fg = colors.pink },
	["@constructor.tsx"] = { fg = colors.pink },
	["@tag.attribute.tsx"] = { fg = colors.cyan_bright, italic = true },

	-- YAML (Enhanced for vibrant syntax)
	["@variable.member.yaml"] = { fg = colors.cyan_bright },
	["@field.yaml"] = { fg = colors.cyan_bright },
	["@string.yaml"] = { fg = colors.pink_bright },
	["@number.yaml"] = { fg = colors.purple_dark },
	["@boolean.yaml"] = { fg = colors.pink },
	["@constant.yaml"] = { fg = colors.purple },
	["@constant.builtin.yaml"] = { fg = colors.coral }, -- for null values
	["@punctuation.delimiter.yaml"] = { fg = colors.purple },
	["@punctuation.special.yaml"] = { fg = colors.yellow },
	["@label.yaml"] = { fg = colors.pink, bold = true },
	["@type.yaml"] = { fg = colors.yellow },
	["@keyword.yaml"] = { fg = colors.purple },
	["@string.special.yaml"] = { fg = colors.coral },
	["@comment.yaml"] = { fg = colors.purple_muted, italic = true },
	["@operator.yaml"] = { fg = colors.cyan }, -- for merge operators like <<
	["@variable.yaml"] = { fg = colors.pink }, -- for anchors and aliases

	-- Ruby
	["@string.special.symbol.ruby"] = { fg = colors.pink },

	-- PHP
	["@function.method.php"] = { link = "Function" },
	["@function.method.call.php"] = { link = "Function" },

	-- C/CPP
	["@type.builtin.c"] = { fg = colors.yellow },
	["@property.cpp"] = { fg = colors.fg },
	["@type.builtin.cpp"] = { fg = colors.yellow },

	-- Python decorators
	["@attribute.python"] = { fg = colors.green_bright },

	-- JavaScript/JSX
	["@keyword.export"] = { fg = colors.cyan },

	-- Gitignore
	["@string.special.path.gitignore"] = { fg = colors.fg },

	-- Misc
	["zshKSHFunction"] = { link = "Function" },

	-- Add keyword modifiers and special operators
	["@keyword.modifier"] = { fg = colors.purple },
	["@keyword.type"] = { fg = colors.purple },

	-- -- Legacy mappings for backward compatibility
	["@parameter"] = { link = "@variable.parameter" },
	["@field"] = { link = "@variable.member" },
	["@namespace"] = { link = "@module" },
	["@float"] = { link = "@number.float" },
	["@symbol"] = { link = "@string.special.symbol" },
	["@string.regex"] = { link = "@string.regexp" },
	["@text"] = { link = "@markup" },
	["@text.strong"] = { link = "@markup.strong" },
	["@text.emphasis"] = { link = "@markup.italic" },
	["@text.underline"] = { link = "@markup.underline" },
	["@text.strike"] = { link = "@markup.strikethrough" },
	["@text.title"] = { link = "@markup.heading" },
	["@text.literal"] = { link = "@markup.raw" },
	["@text.uri"] = { link = "@markup.link.url" },
	["@text.reference"] = { link = "@markup.link" },
	["@method"] = { link = "@function.method" },
	["@method.call"] = { link = "@function.method.call" },
}

-- Apply the theme
for group, hl in pairs(highlights) do
	vim.api.nvim_set_hl(0, group, hl)
end

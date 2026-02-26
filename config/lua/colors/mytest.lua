local colors = {
	bg_darker = "#0D0C1E",
	bg_dark = "#1b1a33",
	bg_medium_dark = "#28274d",
	bg_medium = "#434180",
	bg_medium_light = "#504e99",
	bg_medium_lighter = "#6b68cc",
	bg_light = "#7975e6",
	bg_lighter = "#8682ff",

	light_yellow = "#d7a65f",
	blue = "#0026e6",
	light_blue = "#0060e6",
	light_purple = "#9933ff",
	purple = "#8c33ff",
	orange = "#e68600",
	cyan = "#00dee6",
	light_cyan = "#00e6b8",
	green = "#12de00",
	pink = "#ea00d9",
	gray = "#4A5057",

	tomato_red = "#f44336",
	dark_pink = "#b300a7",
	dark_green = "#66bb6a",
};

-- Used for the columns set with 'colorcolumn'.
ColorColumn
-- Placeholder characters substituted for concealed
Conceal
-- Current match for the last search pattern (see 'hlsearch').
CurSearch
-- Character under the cursor.
Cursor
-- Character under the cursor when |language-mapping|
lCursor
-- Like Cursor, but used when in IME mode. *CursorIM*
CursorIM
-- Screen-column at the cursor, when 'cursorcolumn' is set.
CursorColumn
-- Screen-line at the cursor, when 'cursorline' is set.
CursorLine
-- Directory names (and other special names in listings).
Directory
-- Diff mode: Added line. |diff.txt|
DiffAdd
-- Diff mode: Changed line. |diff.txt|
DiffChange
-- Diff mode: Deleted line. |diff.txt|
DiffDelete
-- Diff mode: Changed text within a changed line. |diff.txt|
DiffText
-- Filler lines (~) after the end of the buffer.
EndOfBuffer
-- Cursor in a focused terminal.
TermCursor
-- Error messages on the command line.
ErrorMsg
-- Separators between window splits.
WinSeparator
-- Line used for closed folds.
Folded
-- 'foldcolumn'
FoldColumn
-- Column where |signs| are displayed.
SignColumn
-- 'incsearch' highlighting; also used for the text replaced with
IncSearch
-- |:substitute| replacement text highlighting.
Substitute
-- Line number for ":number" and ":#" commands, and when 'number'
LineNr
-- Line number for when the 'relativenumber'
LineNrAbove
-- Line number for when the 'relativenumber'
LineNrBelow
-- Like LineNr when 'cursorline' is set and 'cursorlineopt'
CursorLineNr
-- Like FoldColumn when 'cursorline' is set for the cursor line.
CursorLineFold
-- Like SignColumn when 'cursorline' is set for the cursor line.
CursorLineSign
-- Character under the cursor or just before it, if it
MatchParen
-- 'showmode' message (e.g., "-- INSERT --").
ModeMsg
-- Area for messages and command-line, see also 'cmdheight'.
MsgArea
-- Separator for scrolled messages |msgsep|.
MsgSeparator
-- |more-prompt|
MoreMsg
-- '@' at the end of the window, characters from 'showbreak'
NonText
-- Normal text.
Normal
-- Normal text in floating windows.
NormalFloat
-- Border of floating windows.
FloatBorder
-- Title of floating windows.
FloatTitle
-- Footer of floating windows.
FloatFooter
-- Normal text in non-current windows.
NormalNC
-- Popup menu: Normal item.
Pmenu
-- Popup menu: Selected item. Combined with |hl-Pmenu|.
PmenuSel
-- Popup menu: Normal item "kind".
PmenuKind
-- Popup menu: Selected item "kind".
PmenuKindSel
-- Popup menu: Normal item "extra text".
PmenuExtra
-- Popup menu: Selected item "extra text".
PmenuExtraSel
-- Popup menu: Scrollbar.
PmenuSbar
-- Popup menu: Thumb of the scrollbar.
PmenuThumb
-- Popup menu: Matched text in normal item. Combined with
PmenuMatch
-- Popup menu: Matched text in selected item. Combined with
PmenuMatchSel
-- Matched text of the currently inserted completion.
ComplMatchIns
-- |hit-enter| prompt and yes/no questions.
Question
-- Current |quickfix| item in the quickfix window. Combined with
QuickFixLine
-- 	Last search pattern highlighting (see 'hlsearch').
Search
-- Tabstops in snippets. |vim.snippet|
SnippetTabstop
-- Unprintable characters: Text displayed differently from what
SpecialKey
-- Word that is not recognized by the spellchecker. |spell|
SpellBad
-- Word that should start with a capital. |spell|
SpellCap
-- Word that is recognized by the spellchecker as one that is
SpellLocal
-- Word that is recognized by the spellchecker as one that is
SpellRare
-- Status line of current window.
StatusLine
-- Status lines of not-current windows.
StatusLineNC
-- Status line of |terminal| window.
StatusLineTerm
StatusLineTermNC
-- 	Tab pages line, not active tab page label.
TabLine
-- Tab pages line, where there are no labels.
TabLineFill
-- Tab pages line, active tab page label.
TabLineSel
-- 	Titles for output from ":set all", ":autocmd" etc.
Title
-- 	Visual mode selection.
Visual
-- Visual mode selection when vim is "Not Owning the Selection".
VisualNOS
-- Warning messages.
WarningMsg
-- "nbsp", "space", "tab", "multispace", "lead" and "trail"
Whitespace
-- Current match in 'wildmenu' completion.
WildMenu
-- 	Window bar of current window.
WinBar
-- Window bar of not-current windows.
WinBarNC

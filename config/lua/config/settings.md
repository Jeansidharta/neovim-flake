# Settings

This file has all of neovim's options that I use. These control how the core
editor behaves

## Basic config everyone should have

Sets a leader key. This is my personal favorite, but could be anything

```lua
vim.g.mapleader = " "
```

Enables filetype specific events/actions. No reason not to have it

```lua
vim.cmd([[filetype plugin on]])
```

Makes the jump list work in a more intuitive manner, where jumps are placed in a
stack that can be traversed with the `<C-O>` and `<C-I>`

```lua
vim.opt.jumpoptions:append("stack")
```

Sets a column to always be highlighted. This is to make sure your code lines
aren't too long

```lua
vim.opt.colorcolumn:append("100")
```

Allow terminal true color. Enables neovim to use the full RGB colors that most
modern terminal emulators support, instead of the old 16 colors table

```lua
vim.o.termguicolors = true
```

Allow neovim to use the system clipboad

```lua
vim.opt.clipboard:append("unnamedplus")
```

## LSP Debug

Allow for easier debugging of the LSP. **This is disabled until needed.**

This option forces neovim to log every single LSP request and response that is
exchanged with the _Language Server_

```lua
-- vim.lsp.set_log_level 'debug'
```

Changes the default format function for LSP logs. The default will usually dump
a lua object stringified into a single line. Changing that to `vim.inspect`
makes that object print in a much readable way

```lua
-- require('vim.lsp.log').set_format_func(vim.inspect)
```

## Ruler options

Changes how the number bar is displayed

```lua
vim.o.number = true
vim.o.ruler = true
vim.o.relativenumber = true
```

## Encoding options

Everything should always be utf-8. BOM marks are generally useless though, since
everything should be utf-8 anyway, so they are disabled

```lua
vim.o.encoding = "utf-8"
vim.o.fileencodings = "utf-8"
vim.o.bomb = false
```

## Sign Column

The sign column is the column to the left of the lines number column. These
settings define what characters should be associate with which information

```lua
vim.o.signcolumn = "yes"
vim.opt.fillchars:append("foldclose:▾")
vim.opt.fillchars:append("foldopen:▸")
vim.opt.fillchars:append("foldsep: ")
vim.opt.fillchars:append("eob: ")

vim.fn.sign_define({
	{ name = "DiagnosticSignError", text = "⚠", texthl = "DiagnosticError" },
	{ name = "DiagnosticSignWarn", text = "⚠", texthl = "DiagnosticWarn" },
	{ name = "DiagnosticSignInfo", text = "?", texthl = "DiagnosticInfo" },
	{ name = "DiagnosticSignHint", text = "?", texthl = "DiagnosticHint" },
})
```

## Search options

Options related to any editor search.

```lua
vim.o.hlsearch = true -- Highlight items that match search
vim.o.wrapscan = true -- Wrap search from the end of the document to the start
vim.o.incsearch = true -- Match search pattern as the user is typing
vim.o.ignorecase = true -- Will ignore case by default
vim.o.smartcase = true -- If the user has mixed casing, then casing is relevat. Otherwise, ignore it
vim.o.infercase = true -- basically smartcase but for keyword search in insert mode.
```

## Tab config

Size configurations:

```lua
vim.o.tabstop = 4
vim.o.shiftwidth = 0
```

Render tab characters. These option are unnecessary with the
[**indent_blankline**](https://github.com/lukas-reineke/indent-blankline.nvim)
plugin

```lua
--set list
--set listchars=tab:>\
```

## Disable timeout

Timeout makes neovim cancel a keybind chord if the user fails to press anything
in a set time. This is annoying when making a complex macro that requires
thinking

```lua
vim.o.timeout = false
```

For a while, I had a bug when moving to Hyprland regarding this option and the clipboard. Whenever I'd suspend neovim with CTRL-Z, and restore it with `fg`, Neovim would paste its clipboard contents. This would result in me seeing some jumbled lines when resuming Neovim, and being forced to undo the last action (which was the paste command). I spent some time debugging the issue, and realized it went away when disabling this option. This is not really used by my config, and was only set out of completeness, since I also set the `timeout` option above. Therefore, I'm commenting this line for now, and will try to uncoment it from time to time to check if the issue went away by itself.

```lua
-- vim.o.ttimeout = false
```

## Undo file

Enables the undo tree to persist undos between neovim sessions. That means you
won't have to be afraid of losing your undo history after closing neovim. This
also ensures the undo files are stored in an appropriate directory (this would
probably end up being `~/.local/share/nvim/undofiles` in a regular XDG based
system)

```lua
local undo_dir = vim.fn.stdpath("data") .. "/undofiles"
if vim.fn.isdirectory(undo_dir) == 0 then
	vim.fn.mkdir(undo_dir, "", 448) -- 448 is 700 perm
end
vim.o.undodir = undo_dir
vim.o.undofile = true
```

## Splitting

Makes sure splits are made either below the current window (in a vertical split)
or to the right (in a horizontal split)

```lua
vim.o.splitbelow = true
vim.o.splitright = true
```

## Misc

The `equalprg` option sets what program should be used to execute with the `=`
command in normal mode. This is set to `sh` to allow us to run a random line as
if it was a shell command.

```lua
vim.opt.equalprg = "sh"
```

This options makes so inotifywait works with files being edited by vim

```lua
vim.o.backupcopy = "yes"
```

Makes so the matching parenthesis and brackets don't jump when placed

```lua
vim.o.matchtime = 0
vim.o.showmatch = true
```

Prevent windows from changing sizes when a new window is created

```lua
vim.o.equalalways = false
```

Makes so some plugins work better

```lua
vim.o.updatetime = 300
```

Auto sync between neovim processes. It disables swapfiles too, but they're not
really that useful to me

```lua
vim.opt.autoread = true
vim.opt.swapfile = false
```

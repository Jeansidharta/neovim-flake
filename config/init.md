# nit.vim

This neovim configuration has two modules:

## `config`

Has all the settings and keymaps necessary. Also has a utils module that is
useful for the rest of the configureation

```lua
require("config.settings")
require("config.keymaps")
```

## `plugins`

Contains the configurations relevant to any installed plugins.

```lua
require("plugins")
```

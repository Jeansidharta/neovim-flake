{
  plugins,
  init_lua,
  # lib
  linkFarm,
  writeShellApplication,

  neovim,
  sqlite,
  extraPackages,
  git,

  # For treesitter
  gcc,
  ...
}:
let
  plugins_dir = linkFarm "neovim-plugins" plugins;
  sqlite_lib_path = "${sqlite.out}/lib/libsqlite3.so";
in
writeShellApplication {
  name = "nvim";

  runtimeInputs = [
    neovim
    git
    # For treesitter
    gcc
  ]
  ++ extraPackages;

  runtimeEnv = {
    # Provides a config file for prettierd
    PRETTIERD_DEFAULT_CONFIG = ./prettierrc.json;
    # For the zk plugin. This should be your ZK notebook directory
    ZK_NOTEBOOK_DIR = "/home/sidharta/notes";
  };

  text = ''
    export TREESITTER_INSTALL_DIR=~/.local/state/treesitter

    nvim \
      --cmd "let g:sqlite_clib_path=\"${sqlite_lib_path}\"" \
      --cmd "let &runtimepath.=',' .. \"${plugins_dir.outPath}/*\"" \
      -u ${init_lua} "$@"
  '';
}

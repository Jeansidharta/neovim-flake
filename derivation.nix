{
  plugins,
  init_lua,
  # lib
  linkFarm,
  writeShellApplication,

  neovim,
  sqlite,
  ripgrep,
  unixtools,
  lua-language-server,
  gleam,
  astro-language-server,
  nodePackages_latest,
  vscode-langservers-extracted,
  nginx-language-server,
  emmet-language-server,
  nodejs,
  sqls,
  marksman,
  svelte-language-server,
  terraform-ls,
  zk,
  nil,
  rust-analyzer,
  clang-tools,
  openscad-lsp,
  prettierd,
  stylua,
  leptosfmt,
  selene,
  nixfmt-rfc-style,
  eslint,

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

    # Tools
    ripgrep
    unixtools.xxd

    # Language servers
    lua-language-server
    gleam
    # zls-master
    astro-language-server
    nodePackages_latest.typescript-language-server
    nodePackages_latest.bash-language-server
    vscode-langservers-extracted
    nginx-language-server
    emmet-language-server
    nodejs
    sqls
    marksman
    svelte-language-server
    terraform-ls
    zk
    nil
    rust-analyzer
    clang-tools
    openscad-lsp

    # Null ls programs
    prettierd
    stylua
    leptosfmt
    selene
    nixfmt-rfc-style
    eslint

    # For treesitter
    gcc
  ];

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

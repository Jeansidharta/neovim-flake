{
  description = "Neovim with plugins";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Libraries
    plenary = {
      url = "github:nvim-lua/plenary.nvim/master";
      flake = false;
    };
    sqlite = {
      url = "github:kkharji/sqlite.lua/master";
      flake = false;
    };
    git-magnum = {
      url = "github:glts/vim-magnum/master";
      flake = false;
    };

    # Plugins
    neoclip = {
      url = "github:AckslD/nvim-neoclip.lua/main";
      flake = false;
    };
    tokyodark = {
      url = "github:jeansidharta/tokyodark.nvim/master";
      flake = false;
    };
    telescope = {
      url = "github:nvim-telescope/telescope.nvim/master";
      flake = false;
    };
    nvim-notify = {
      url = "github:rcarriga/nvim-notify/master";
      flake = false;
    };
    git-conflict = {
      url = "github:akinsho/git-conflict.nvim/main";
      flake = false;
    };
    git-radical = {
      url = "github:glts/vim-radical/master";
      flake = false;
    };
    lsp-lines = {
      url = "git+https://git.sr.ht/~whynothugo/lsp_lines.nvim?ref=main";
      flake = false;
    };
    deferred-clipboard = {
      url = "github:EtiamNullam/deferred-clipboard.nvim/master";
      flake = false;
    };
    oil = {
      url = "github:stevearc/oil.nvim/master";
      flake = false;
    };
    substitute = {
      url = "github:gbprod/substitute.nvim/main";
      flake = false;
    };
    bufjump = {
      url = "github:kwkarlwang/bufjump.nvim/master";
      flake = false;
    };
    fidget = {
      url = "github:j-hui/fidget.nvim/main";
      flake = false;
    };
    smart-splits = {
      url = "github:mrjones2014/smart-splits.nvim/master";
      flake = false;
    };
    dressing = {
      url = "github:stevearc/dressing.nvim/master";
      flake = false;
    };
    git-signs = {
      url = "github:lewis6991/gitsigns.nvim/main";
      flake = false;
    };
    hover = {
      url = "github:lewis6991/hover.nvim/main";
      flake = false;
    };
    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim/master";
      flake = false;
    };
    lualine = {
      url = "github:nvim-lualine/lualine.nvim/master";
      flake = false;
    };
    luasnip = {
      url = "github:L3MON4D3/LuaSnip/master";
      flake = false;
    };
    mdeval = {
      url = "github:jubnzv/mdeval.nvim/master";
      flake = false;
    };
    none-ls = {
      url = "github:nvimtools/none-ls.nvim/main";
      flake = false;
    };
    mini-completion = {
      url = "github:echasnovski/mini.completion/main";
      flake = false;
    };
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig/master";
      flake = false;
    };
    overseer = {
      url = "github:stevearc/overseer.nvim/master";
      flake = false;
    };
    status-col = {
      url = "github:luukvbaal/statuscol.nvim/main";
      flake = false;
    };
    treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter/master";
      flake = false;
    };
    nvim-illuminate = {
      url = "github:RRethy/vim-illuminate/master";
      flake = false;
    };
    various-textobjs = {
      url = "github:chrisgrieser/nvim-various-textobjs/main";
      flake = false;
    };
    parinfer-rust = {
      url = "github:eraserhd/parinfer-rust/master";
      flake = false;
    };
    guess-indent = {
      url = "github:NMAC427/guess-indent.nvim/main";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      # System types to support.
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
          lib = pkgs.lib;

          # This plugin needs to be built before being used. Thankfully, it already has
          # a derivation in its repo. We just have to import it and call it.
          parinfer = pkgs.callPackage (import "${inputs.parinfer-rust}/derivation.nix") { };

          plugins_runtimepath =
            with lib.attrsets;
            with builtins;
            (
              let
                not-plugins = [
                  "nixpkgs"
                  "parinfer-rust"
                ];
                plugins_attr = filterAttrs (name: _: !elem name not-plugins) inputs;
                plugins = map (p: p.outPath) (attrValues plugins_attr);
                plugins_with_config = plugins ++ [ "${./config-lua}" ];
              in
              lib.concatStringsSep "," plugins_with_config
            )
            # Parinfer is a regular vimscript plugin
            + ",${parinfer}/share/vim-plugins/parinfer-rust";
          sqlite_lib_path = "${pkgs.sqlite.out}/lib/libsqlite3.so";
        in
        {
          default = pkgs.writeShellApplication {
            name = "nvim";

            runtimeInputs = with pkgs; [
              neovim

              # Tools
              ripgrep

              # Language servers
              lua-language-server
              gleam
              zls
              nodePackages_latest.typescript-language-server
              nodePackages_latest.bash-language-server
              vscode-langservers-extracted
              nginx-language-server
              sqls
              marksman
              svelte-language-server
              terraform-ls
              zk
              nil
              rust-analyzer

              # Null ls programs
              prettierd
              stylua
              leptosfmt
              selene
              nixfmt-rfc-style

              # For treesitter
              gcc
            ];

            runtimeEnv = {
              # Provides a config file for prettierd
              PRETTIERD_DEFAULT_CONFIG = ./prettierrc.json;
            };

            text = ''
              export TREESITTER_INSTALL_DIR=~/.local/state/treesitter

              nvim \
                --cmd "let g:sqlite_clib_path=\"${sqlite_lib_path}\"" \
                --cmd "let &runtimepath.=',' .. \"${plugins_runtimepath}\"" \
                -u ${./config-lua}/init.lua "$@"
            '';
          };
        }
      );
    };
}

{
  description = "Neovim with plugins";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    theme.url = "github:jeansidharta/configuration.nix?dir=theming";

    # Literate programming builder
    literate-markdown = {
      url = "github:jeansidharta/literate-markdown";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Libraries
    plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    sqlite = {
      url = "github:kkharji/sqlite.lua";
      flake = false;
    };
    git-magnum = {
      url = "github:glts/vim-magnum";
      flake = false;
    };

    # Plugins
    neoclip = {
      url = "github:AckslD/nvim-neoclip.lua";
      flake = false;
    };
    tiny-glimmer = {
      url = "github:rachartier/tiny-glimmer.nvim";
      flake = false;
    };
    oil-lsp-diagnostics = {
      url = "github:JezerM/oil-lsp-diagnostics.nvim";
      flake = false;
    };
    nvim-colorizer = {
      url = "github:catgoose/nvim-colorizer.lua";
      flake = false;
    };
    tokyodark = {
      url = "github:jeansidharta/tokyodark.nvim";
      flake = false;
    };
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    nvim-notify = {
      url = "github:rcarriga/nvim-notify";
      flake = false;
    };
    git-conflict = {
      url = "github:akinsho/git-conflict.nvim";
      flake = false;
    };
    git-radical = {
      url = "github:glts/vim-radical";
      flake = false;
    };
    lsp-lines = {
      url = "git+https://git.sr.ht/~whynothugo/lsp_lines.nvim?ref=main";
      flake = false;
    };
    oil = {
      url = "github:stevearc/oil.nvim";
      flake = false;
    };
    substitute = {
      url = "github:gbprod/substitute.nvim";
      flake = false;
    };
    bufjump = {
      url = "github:kwkarlwang/bufjump.nvim";
      flake = false;
    };
    fidget = {
      url = "github:j-hui/fidget.nvim";
      flake = false;
    };
    smart-splits = {
      url = "github:mrjones2014/smart-splits.nvim";
      flake = false;
    };
    dressing = {
      url = "github:stevearc/dressing.nvim";
      flake = false;
    };
    git-signs = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    hover = {
      url = "github:lewis6991/hover.nvim";
      flake = false;
    };
    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };
    luasnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };
    mdeval = {
      url = "github:jeansidharta/mdeval.nvim";
      flake = false;
    };
    none-ls = {
      url = "github:nvimtools/none-ls.nvim";
      flake = false;
    };
    blink = {
      url = "github:Saghen/blink.cmp";
    };
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    overseer = {
      url = "github:stevearc/overseer.nvim";
      flake = false;
    };
    status-col = {
      url = "github:luukvbaal/statuscol.nvim";
      flake = false;
    };
    treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    nvim-illuminate = {
      url = "github:RRethy/vim-illuminate";
      flake = false;
    };
    various-textobjs = {
      url = "github:chrisgrieser/nvim-various-textobjs";
      flake = false;
    };
    parinfer-rust = {
      url = "github:eraserhd/parinfer-rust";
      flake = false;
    };
    guess-indent = {
      url = "github:NMAC427/guess-indent.nvim";
      flake = false;
    };
    snipe = {
      url = "github:jeansidharta/snipe.nvim/feat-menu-context";
      flake = false;
    };
    markview = {
      url = "github:OXY2DEV/markview.nvim";
      flake = false;
    };
    otter = {
      url = "github:jmbuhr/otter.nvim";
      flake = false;
    };
    zk-nvim = {
      url = "github:zk-org/zk-nvim";
      flake = false;
    };
    outline = {
      url = "github:hedyhli/outline.nvim";
      flake = false;
    };
    hex = {
      url = "github:RaafatTurki/hex.nvim";
      flake = false;
    };

    # LSPs
    openscad-lsp = {
      url = "github:Leathong/openscad-LSP";
      flake = false;
    };
    zls.url = "github:zigtools/zls";
  };

  outputs =
    {
      self,
      nixpkgs,
      theme,
      ...
    }@inputs:
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

          # These plugins need to be built before being used.
          parinfer = pkgs.callPackage (import "${inputs.parinfer-rust}/derivation.nix") { };
          blink = inputs.blink.outputs.packages.${system}.default;
          # The master version of the Zig Language Server
          zls-master = inputs.zls.outputs.packages.${system}.default;

          parsed_config =
            let
              literate-markdown-bin = "${
                inputs.literate-markdown.outputs.packages.${system}.default
              }/bin/literate-markdown";
              fd-bin = "${pkgs.fd}/bin/fd";
            in
            pkgs.runCommand "parsed-config" { } ''
              mkdir $out
              cd ${./config}
              cp -r --no-preserve=mode . $out
              ${fd-bin} . -e md -t f --strip-cwd-prefix -x ${literate-markdown-bin} "{}" "$out/{.}.lua" \;
            '';

          plugins_runtimepath =
            with lib.attrsets;
            with builtins;
            (
              let
                not-plugins = [
                  "nixpkgs"
                  "zls"
                  "openscad-lsp"
                  "theme"
                  # We are building these ourselves. Remove from automatic inclusion
                  "parinfer-rust"
                  "blink"
                ];
                plugins_attr = filterAttrs (name: _: !elem name not-plugins) inputs;
                plugins = map (p: p.outPath) (attrValues plugins_attr);
                plugins_with_config = plugins ++ [ "${parsed_config}" ];
              in
              lib.concatStringsSep "," plugins_with_config
            )
            # These we had to build before adding
            + ",${parinfer}/share/vim-plugins/parinfer-rust"
            + ",${blink}";
          sqlite_lib_path = "${pkgs.sqlite.out}/lib/libsqlite3.so";
        in
        {
          parsed-config = parsed_config;
          default = pkgs.writeShellApplication {
            name = "nvim";

            runtimeInputs = with pkgs; [
              neovim

              # Tools
              ripgrep
              unixtools.xxd

              # Language servers
              lua-language-server
              gleam
              zls-master
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
              clang-tools
              (pkgs.callPackage (
                {
                  lib,
                  rustPlatform,
                }:

                rustPlatform.buildRustPackage {
                  pname = "openscad-lsp";
                  version = "1.2.5";
                  src = inputs.openscad-lsp;
                  cargoHash = "sha256-JaX/BokVeHcD/38zbUFYucAqpASSxV9gvvjYvjX7xdA=";
                  # no tests exist
                  doCheck = false;

                  meta = with lib; {
                    description = "A LSP (Language Server Protocol) server for OpenSCAD";
                    mainProgram = "openscad-lsp";
                    homepage = "https://github.com/Leathong/openscad-LSP";
                    license = licenses.asl20;
                  };
                }
              ) { })

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
                --cmd "let &runtimepath.=',' .. \"${plugins_runtimepath}\"" \
                -u ${parsed_config}/init.lua "$@"
            '';
          };
        }
      );
    };
}

{
  description = "Neovim with plugins";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    theme.url = "github:jeansidharta/configuration.nix?dir=theming";

    # Literate programming builder
    literate-markdown = {
      url = "github:jeansidharta/literate-markdown";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Libraries
    plenary_plugin = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    sqlite_plugin = {
      url = "github:kkharji/sqlite.lua";
      flake = false;
    };
    git-magnum_plugin = {
      url = "github:glts/vim-magnum";
      flake = false;
    };

    # Plugins
    neoclip_plugin = {
      url = "github:AckslD/nvim-neoclip.lua";
      flake = false;
    };
    oil-lsp-diagnostics_plugin = {
      url = "github:JezerM/oil-lsp-diagnostics.nvim";
      flake = false;
    };
    oil-git-status_plugin = {
      url = "github:refractalize/oil-git-status.nvim";
      flake = false;
    };
    nvim-colorizer_plugin = {
      url = "github:catgoose/nvim-colorizer.lua";
      flake = false;
    };
    treewalker_plugin = {
      url = "github:aaronik/treewalker.nvim";
      flake = false;
    };
    tokyodark_plugin = {
      url = "github:jeansidharta/tokyodark.nvim";
      flake = false;
    };
    telescope_plugin = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    nvim-notify_plugin = {
      url = "github:rcarriga/nvim-notify";
      flake = false;
    };
    git-conflict_plugin = {
      url = "github:akinsho/git-conflict.nvim";
      flake = false;
    };
    git-radical_plugin = {
      url = "github:glts/vim-radical";
      flake = false;
    };
    lsp-lines_plugin = {
      url = "git+https://git.sr.ht/~whynothugo/lsp_lines.nvim?ref=main";
      flake = false;
    };
    oil_plugin = {
      url = "github:stevearc/oil.nvim";
      flake = false;
    };
    substitute_plugin = {
      url = "github:gbprod/substitute.nvim";
      flake = false;
    };
    bufjump_plugin = {
      url = "github:kwkarlwang/bufjump.nvim";
      flake = false;
    };
    fidget_plugin = {
      url = "github:j-hui/fidget.nvim";
      flake = false;
    };
    dressing_plugin = {
      url = "github:stevearc/dressing.nvim";
      flake = false;
    };
    git-signs_plugin = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    indent-blankline_plugin = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    lualine_plugin = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };
    luasnip_plugin = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };
    mdeval_plugin = {
      url = "github:jeansidharta/mdeval.nvim";
      flake = false;
    };
    none-ls_plugin = {
      url = "github:nvimtools/none-ls.nvim";
      flake = false;
    };
    # This is a plugin, but wont have the plugin prefix because it has
    # to be handled separately, as it is a proper flake.
    blink = {
      url = "github:Saghen/blink.cmp";
    };
    nvim-lspconfig_plugin = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    overseer_plugin = {
      url = "github:stevearc/overseer.nvim";
      flake = false;
    };
    status-col_plugin = {
      url = "github:luukvbaal/statuscol.nvim";
      flake = false;
    };
    treesitter_plugin = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    nvim-illuminate_plugin = {
      url = "github:RRethy/vim-illuminate";
      flake = false;
    };
    various-textobjs_plugin = {
      url = "github:chrisgrieser/nvim-various-textobjs";
      flake = false;
    };
    # This is a plugin, but wont have the plugin prefix because it has
    # to be built before being used, and because the plugin directory
    # is weird, so we must handle that separately
    parinfer-rust = {
      url = "github:eraserhd/parinfer-rust";
      flake = false;
    };
    markview_plugin = {
      url = "github:OXY2DEV/markview.nvim";
      flake = false;
    };
    zk-nvim_plugin = {
      url = "github:zk-org/zk-nvim";
      flake = false;
    };
    outline_plugin = {
      url = "github:hedyhli/outline.nvim";
      flake = false;
    };

    # LSPs
    openscad-lsp = {
      url = "github:Leathong/openscad-LSP";
      flake = false;
    };
    zig-overlay.url = "github:mitchellh/zig-overlay";
    zls = {
      url = "github:zigtools/zls";
      inputs.zig-overlay.follows = "zig-overlay";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
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

          plugins_dir = (
            let
              inherit (lib.strings) hasSuffix removeSuffix;
              inherit (lib.attrsets) mapAttrs' filterAttrs nameValuePair;
              plugins_attr = filterAttrs (name: _: hasSuffix "_plugin" name) inputs;
              plugins = mapAttrs' (
                name: value: nameValuePair (removeSuffix "_plugin" name) value.outPath
              ) plugins_attr;
              plugins_with_config = plugins // {
                personal-config = "${parsed_config}";
                # These we had to build before adding
                parinfer = "${parinfer}/share/vim-plugins/parinfer-rust";
                blink = "${blink}";
              };
            in
            pkgs.linkFarm "neovim-plugins" plugins_with_config
          );
          sqlite_lib_path = "${pkgs.sqlite.out}/lib/libsqlite3.so";
        in
        {
          plugins_dir = plugins_dir;
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
              (pkgs.callPackage (
                {
                  lib,
                  rustPlatform,
                }:
                rustPlatform.buildRustPackage {
                  pname = "openscad-lsp";
                  version = "1.2.5";
                  src = inputs.openscad-lsp;
                  useFetchCargoVendor = true;
                  cargoHash = "sha256-EscpHTBH6R7sBmIxTH/n5zTs2YahXRh4HTWWgq50Lh8=";
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
              nixpkgs-stable.legacyPackages.${system}.eslint

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
                -u ${parsed_config}/init.lua "$@"
            '';
          };
        }
      );
    };
}

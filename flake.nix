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
    snacks_plugin = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };
    fyler_plugin = {
      url = "github:A7Lavinraj/fyler.nvim/v2.0.0";
      flake = false;
    };
    silkcircuit_plugin = {
      url = "github:hyperb1iss/silkcircuit-nvim";
      flake = false;
    };
    # Dependency for fyler.nvim
    mini-icons_plugin = {
      url = "github:echasnovski/mini.icons";
      flake = false;
    };
    neovim-dap_plugin = {
        url = "github:mfussenegger/nvim-dap";
        flake = false;
    };
    nvim-web-devicons_plugin = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };
    nvim-colorizer_plugin = {
      url = "github:catgoose/nvim-colorizer.lua";
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
    blink-cmp-words_plugin = {
      url = "github:archie-judd/blink-cmp-words";
      flake = false;
    };
    nvim-lspconfig_plugin = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    overseer_plugin = {
      url = "github:stevearc/overseer.nvim";
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
    attone_plugin = {
      url = "github:XXiaoA/atone.nvim";
      flake = false;
    };
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
          blink = inputs.blink.outputs.packages.${system}.default;
          # The master version of the Zig Language Server
          # zls-master = inputs.zls.outputs.packages.${system}.default;

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
              ${fd-bin} . -e md -t f --strip-cwd-prefix -x ${literate-markdown-bin} "{}" "$out/{.}.lua" ";"
            '';

          plugins_list =
            let
              inherit (lib.strings) hasSuffix removeSuffix;
              inherit (lib.attrsets) mapAttrs' filterAttrs nameValuePair;
              plugins_attr = filterAttrs (name: _: hasSuffix "_plugin" name) inputs;
            in
            mapAttrs' (name: value: nameValuePair (removeSuffix "_plugin" name) value.outPath) plugins_attr
            // {
              personal-config = "${parsed_config}";
              parinfer = "${pkgs.kakounePlugins.parinfer-rust}/plugin/parinfer.vim";
              blink = "${blink}";
            };
          global-lsps = [
            pkgs.nil
            pkgs.nodePackages_latest.bash-language-server
            pkgs.nixfmt
            pkgs.prettierd
            pkgs.zk
          ];
          lsps = [
            pkgs.rust-analyzer
            pkgs.openscad-lsp
            pkgs.svelte-language-server
            pkgs.emmet-language-server
            pkgs.nodejs
            pkgs.vscode-langservers-extracted
            pkgs.astro-language-server
            pkgs.nodePackages_latest.typescript-language-server
            pkgs.gleam
            pkgs.kakounePlugins.parinfer-rust
            pkgs.terraform-ls
            pkgs.lua-language-server
            pkgs.sqls
            pkgs.nginx-language-server
          ];
          formatters = [
            pkgs.eslint
            pkgs.stylua
            pkgs.selene
            pkgs.nixfmt
            pkgs.prettierd
          ];
          misc-tools = [
            pkgs.ripgrep
            pkgs.unixtools.xxd
            pkgs.marksman
          ];
        in
        rec {
          plugins_dir = pkgs.lib.makeOverridable ({ plugins }: pkgs.linkFarm "neovim-plugins" plugins) {
            plugins = plugins_list;
          };
          base = lib.makeOverridable (final: pkgs.callPackage (import ./derivation.nix) final) {
            plugins = plugins_list;
            init_lua = "${parsed_config}/init.lua";
            extraPackages = [ ];
          };
          simple = base.override (prev: {
            extraPackages = prev.extraPackages ++ misc-tools;
          });
          with-global-lsps = base.override (prev: {
            extraPackages = prev.extraPackages ++ misc-tools ++ global-lsps;
          });
          with-lsps = base.override (prev: {
            extraPackages = prev.extraPackages ++ misc-tools ++ lsps;
          });
          full = base.override (prev: {
            extraPackages = prev.extraPackages ++ misc-tools ++ lsps ++ formatters;
          });
          default = with-global-lsps;

        }
      );
      devShell = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        pkgs.mkShell {
          buildInputs = [
            pkgs.stylua
            pkgs.lua-language-server
          ];
        }
      );
    };
}

{
  description = "Neovim with plugins";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    theme.url = "github:jeansidharta/configuration.nix?dir=theming";

    # Libraries
    plenary_plugin = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    vim-magnum_plugin = {
      url = "github:glts/vim-magnum";
      flake = false;
    };

    # Plugins
    fzf_plugin = {
      url = "github:ibhagwan/fzf-lua";
      flake = false;
    };
    snacks_plugin = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };
    fyler_plugin = {
      url = "github:A7Lavinraj/fyler.nvim";
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
    nvim-notify_plugin = {
      url = "github:rcarriga/nvim-notify";
      flake = false;
    };
    vim-radical_plugin = {
      url = "github:glts/vim-radical";
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
    # treesitter_plugin = {
    #   url = "github:nvim-treesitter/nvim-treesitter";
    #   flake = false;
    # };
    nvim-illuminate_plugin = {
      url = "github:RRethy/vim-illuminate";
      flake = false;
    };
    various-textobjs_plugin = {
      url = "github:chrisgrieser/nvim-various-textobjs";
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

          plugins_list =
            let
              inherit (lib.strings) hasSuffix removeSuffix;
              inherit (lib.attrsets) mapAttrs' filterAttrs nameValuePair;
              plugins_attr = filterAttrs (name: _: hasSuffix "_plugin" name) inputs;
            in
            mapAttrs' (name: value: nameValuePair (removeSuffix "_plugin" name) value.outPath) plugins_attr
            // {
              personal-config = ./config;
              parinfer = "${pkgs.kakounePlugins.parinfer-rust}/plugin/parinfer.vim";
              blink = "${blink}";
            };
          treesitter-parsers = with pkgs.tree-sitter-grammars; {
            html = tree-sitter-html;
            go = tree-sitter-go;
            nix = tree-sitter-nix;
            zig = tree-sitter-zig;
            bash = tree-sitter-bash;
            vue = tree-sitter-vue;
            tsx = tree-sitter-tsx;
            sql = tree-sitter-sql;
            json = tree-sitter-json;
            make = tree-sitter-make;
            toml = tree-sitter-toml;
            yaml = tree-sitter-yaml;
            gleam = tree-sitter-gleam;
            jsdoc = tree-sitter-jsdoc;
            python = tree-sitter-python;
            cs = tree-sitter-c-sharp;
            javascript = tree-sitter-javascript;
            typescript = tree-sitter-typescript;
            supercollider = tree-sitter-supercollider;
          };
          treesitter-dir = pkgs.runCommand "treesitter-parsers" { } (
            ''
              mkdir $out
              mkdir $out/parser
              mkdir $out/queries

              echo 'vim.api.nvim_create_autocmd("FileType", { pattern = {' > $out/treesitter.lua
            ''
            + (lib.join "\n" (
              lib.mapAttrsToList (name: parser: ''
                ln -s '${parser}/parser' "$out/parser/${name}.so"
                ln -s '${parser}/queries' "$out/queries/${name}"
                echo '"${name}",' >> $out/treesitter.lua
              '') treesitter-parsers
            ))
            + ''
              echo '}, callback = function () vim.treesitter.start() end })' >> $out/treesitter.lua
            ''
          );
          global-lsps = [
            pkgs.nil
            pkgs.bash-language-server
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
            pkgs.typescript-language-server
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
          inherit treesitter-dir;
          plugins_dir = pkgs.lib.makeOverridable ({ plugins }: pkgs.linkFarm "neovim-plugins" plugins) {
            plugins = plugins_list;
          };
          base = lib.makeOverridable (final: pkgs.callPackage (import ./derivation.nix) final) {
            inherit treesitter-dir;
            plugins = plugins_list;
            init_lua = ./config/init.lua;
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

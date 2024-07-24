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
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp/main";
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
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = pkgs.lib;

      not-plugins = [ "nixpkgs" ];
      plugins =
        with lib.attrsets;
        with builtins;
        map ({ value, ... }: value) (filter ({ name, ... }: !elem name not-plugins) (attrsToList inputs));

      plugins_runtimepath = "${./config-lua}," + lib.concatMapStringsSep "," (p: p.outPath) plugins;
      sqlite_lib_path = "${pkgs.sqlite.out}/lib/libsqlite3.so";
    in
    {
      packages.${system}.default = pkgs.writeShellApplication {
        name = "nvim";

        runtimeInputs = with pkgs; [
          neovim

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
          # Null ls programs
          prettierd
          stylua
          leptosfmt
          selene
          nixfmt-rfc-style
        ];

        text = ''
          		  # Provides a config file for prettierd
                    export PRETTIERD_DEFAULT_CONFIG=${./prettierrc.json}

                    nvim \
          		    --cmd "let g:sqlite_clib_path=\"${sqlite_lib_path}\"" \
          			--cmd "let &runtimepath.=',' .. \"${plugins_runtimepath}\"" \
          			-u ${./config-lua}/init.lua "$@"
        '';
      };
    };
}

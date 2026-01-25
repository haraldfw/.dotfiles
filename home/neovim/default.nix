{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = [
      pkgs.vimPlugins.nvim-tree-lua
      {
        plugin = pkgs.vimPlugins.vim-startify;
        config = "let g:startify_change_to_vcs_root = 0";
      }
      pkgs.vimPlugins.telescope-nvim
      pkgs.vimPlugins.harpoon2
    ];

    # waylandSupport = true;

    initLua = ''
      vim.opt.number = true;
    '';
  };
}

{ pkgs, ... }:
{
  programs.bottom = {
    enable = true;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;
    withRuby = false;
    withPython3 = true;

    plugins = with pkgs.vimPlugins; [
      nvim-tree-lua
      telescope-nvim
      harpoon2
      lazygit-nvim
      nvim-treesitter.withAllGrammars
    ];

    # waylandSupport = true;

  };
}

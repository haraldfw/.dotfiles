{ pkgs, ... }:
{
  programs.obsidian = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then null else pkgs.obsidian;

    vaults."Documents/Obsidian/main".enable = true;

    defaultSettings = {
      app = {
        defaultViewMode = "preview";
        vimMode = true;
        showLineNumber = true;
      };

      corePlugins = [
        "file-explorer"
        "global-search"
        "switcher"
        "graph"
        "backlink"
        "outgoing-link"
        "command-palette"
        "editor-status"
        "templates"
        "note-composer"
      ];

      hotkeys = {
        "command-palette:open" = [
          {
            modifiers = [
              "Ctrl"
              "Shift"
            ];
            key = "P";
          }
        ];
      };
    };
  };
}

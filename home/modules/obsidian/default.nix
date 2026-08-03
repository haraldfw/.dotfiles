{ pkgs, ... }:
{
  programs.obsidian = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then null else pkgs.obsidian;

    defaultSettings = {
      app = {
        defaultViewMode = "preview";
        vimMode = true;
        showLineNumber = true;
      };

      corePlugins = [
        {
          name = "daily-notes";
          settings = {
            folder = "Daily";
            format = "YYYY-MM-DD";
          };
        }
        {
          name = "templates";
          settings.folder = "Templates";
        }
        "file-explorer"
        "global-search"
        "switcher"
        "graph"
        "backlink"
        "outgoing-link"
        "command-palette"
        "editor-status"
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

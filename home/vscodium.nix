{
  pkgs,
  ...
}:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default = {
      extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
        jnoortheen.nix-ide
        biomejs.biome
        golang.go
        geequlim.godot-tools
        alfish.godot-files
        rust-lang.rust-analyzer
        arrterian.nix-env-selector
      ];
      globalSnippets = {
        "#bash" = {
          body = [
            "#!/usr/bin/env bash"
          ];
          description = "Insert a bash shebang";
          prefix = [
            "#bash"
            "#shebang"
          ];
        };
      };
      userSettings = {
        "editor.renderWhitespace" = "all";
        "biome.lsp.bin" = "/nix/store/i07bwiby5015ilpdg853j71gbfvlay65-system-path/bin/biome";
        "[typescriptreact]" = {
          "editor.defaultFormatter" = "biomejs.biome";
        };
        "editor.formatOnSave" = true;
        "editor.insertSpaces" = false;
        "workbench.colorTheme" = "Monokai";
        "files.insertFinalNewline" = true;
        "files.trimFinalNewlines" = true;
        "files.autoSave" = "onFocusChange";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "[jsonc]" = {
          "editor.defaultFormatter" = "vscode.json-language-features";
        };
      };
      keybindings = [
        {
          "key" = "ctrl+d";
          "command" = "editor.action.deleteLines";
          "when" = "textInputFocus && !editorReadonly";
        }
        {
          "key" = "ctrl+shift+k";
          "command" = "-editor.action.deleteLines";
          "when" = "textInputFocus && !editorReadonly";
        }
        {
          "key" = "ctrl+d";
          "command" = "-editor.action.addSelectionToNextFindMatch";
          "when" = "editorFocus";
        }
        {
          "key" = "ctrl+d";
          "command" = "-notebook.addFindMatchToSelection";
          "when" =
            "config.notebook.multiCursor.enabled && notebookCellEditorFocused && activeEditor == 'workbench.editor.notebook'";
        }
        {
          "key" = "ctrl+tab";
          "command" = "-workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup";
          "when" = "!activeEditorGroupEmpty";
        }
        {
          "key" = "ctrl+tab";
          "command" = "-workbench.action.quickOpenNavigateNextInEditorPicker";
          "when" = "inEditorsPicker && inQuickOpen";
        }
        {
          "key" = "ctrl+shift+tab";
          "command" = "-workbench.action.quickOpenLeastRecentlyUsedEditorInGroup";
          "when" = "!activeEditorGroupEmpty";
        }
        {
          "key" = "ctrl+shift+tab";
          "command" = "-workbench.action.quickOpenNavigatePreviousInEditorPicker";
          "when" = "inEditorsPicker && inQuickOpen";
        }
        {
          "key" = "ctrl+tab";
          "command" = "workbench.action.nextEditor";
        }
        {
          "key" = "ctrl+pagedown";
          "command" = "-workbench.action.nextEditor";
        }
        {
          "key" = "ctrl+shift+tab";
          "command" = "workbench.action.previousEditor";
        }
        {
          "key" = "ctrl+pageup";
          "command" = "-workbench.action.previousEditor";
        }
        {
          "key" = "ctrl+shift+d";
          "command" = "-workbench.view.debug";
          "when" = "viewContainer.workbench.view.debug.enabled";
        }
        {
          "key" = "ctrl+shift+d";
          "command" = "editor.action.duplicateSelection";
        }
        {
          "key" = "alt+up";
          "command" = "-editor.action.moveLinesUpAction";
          "when" = "editorTextFocus && !editorReadonly";
        }
        {
          "key" = "alt+down";
          "command" = "-editor.action.moveLinesDownAction";
          "when" = "editorTextFocus && !editorReadonly";
        }
        {
          "key" = "alt+up";
          "command" = "editor.action.insertCursorAbove";
          "when" = "editorTextFocus";
        }
        {
          "key" = "ctrl+shift+up";
          "command" = "-editor.action.insertCursorAbove";
          "when" = "editorTextFocus";
        }
        {
          "key" = "alt+down";
          "command" = "editor.action.insertCursorBelow";
          "when" = "editorTextFocus";
        }
        {
          "key" = "ctrl+shift+down";
          "command" = "-editor.action.insertCursorBelow";
          "when" = "editorTextFocus";
        }
        {
          "key" = "shift+alt+down";
          "command" = "-editor.action.insertCursorBelow";
          "when" = "editorTextFocus";
        }
        {
          "key" = "shift+alt+up";
          "command" = "-editor.action.insertCursorAbove";
          "when" = "editorTextFocus";
        }
      ];
    };
  };
}

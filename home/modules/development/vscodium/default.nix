{
  pkgs,
  ...
}:
let
  # these settings are used by all profiles
  extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
    arrterian.nix-env-selector
    vscodevim.vim
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
    "editor.fontFamily" = "Fira Code";
    "editor.fontLigatures" = false;
    "editor.renderWhitespace" = "all";
    "editor.formatOnSave" = true;
    "editor.insertSpaces" = false;
    "workbench.colorTheme" = "Monokai";
    "files.insertFinalNewline" = true;
    "files.trimFinalNewlines" = true;
    "files.autoSave" = "onFocusChange";
    "[jsonc]" = {
      "editor.defaultFormatter" = "vscode.json-language-features";
    };
    "vim.easymotion" = true;
    "vim.incsearch" = true;
    "vim.useSystemClipboard" = true;
    "vim.useCtrlKeys" = true;
    "vim.hlsearch" = true;
    "vim.insertModeKeyBindings" = [
      {
        "before" = [
          "j"
          "j"
        ];
        "after" = [ "<Esc>" ];
      }
    ];
    "vim.normalModeKeyBindingsNonRecursive" = [
      {
        "before" = [
          "<leader>"
          "d"
        ];
        "after" = [
          "d"
          "d"
        ];
      }
      {
        "before" = [ "<C-n>" ];
        "commands" = [ ":nohl" ];
      }
      {
        "before" = [ "K" ];
        "commands" = [ "lineBreakInsert" ];
        "silent" = true;
      }
    ];
    "vim.leader" = "<space>";
    "vim.handleKeys" = {
      "<C-a>" = false;
      "<C-f>" = false;
    };
    "extensions.experimental.affinity" = {
      "vscodevim.vim" = 1;
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
      "key" = "ctrl+p";
      "command" = "-extension.vim_ctrl+p";
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
in
{
  programs.vscodium = {
    enable = true;

    profiles.default = {
      extensions = extensions;
      globalSnippets = globalSnippets;
      userSettings = userSettings;
      keybindings = keybindings;
    };

    profiles.c = {
      extensions =
        with pkgs.nix-vscode-extensions.vscode-marketplace;
        [
          llvm-vs-code-extensions.vscode-clangd
        ]
        ++ extensions;
      globalSnippets = globalSnippets;
      userSettings = userSettings;
      keybindings = keybindings;
    };

    profiles.go = {
      extensions =
        with pkgs.nix-vscode-extensions.vscode-marketplace;
        [
          golang.go
        ]
        ++ extensions;
      globalSnippets = globalSnippets;
      userSettings = userSettings;
      keybindings = keybindings;
    };

    profiles.godot = {
      extensions =
        with pkgs.nix-vscode-extensions.vscode-marketplace;
        [
          geequlim.godot-tools
          alfish.godot-files
        ]
        ++ extensions;
      globalSnippets = globalSnippets;
      userSettings = userSettings;
      keybindings = keybindings;
    };

    profiles.js = {
      extensions =
        with pkgs.nix-vscode-extensions.vscode-marketplace;
        [
          biomejs.biome
        ]
        ++ extensions;
      globalSnippets = globalSnippets;
      userSettings = userSettings // {
        "biome.lsp.bin" = pkgs.biome.outPath + "/bin/biome";
        "[typescriptreact]" = {
          "editor.defaultFormatter" = "biomejs.biome";
        };
      };
      keybindings = keybindings;
    };

    profiles.nix = {
      extensions =
        with pkgs.nix-vscode-extensions.vscode-marketplace;
        [
          jnoortheen.nix-ide
          atomicspirit.nix-embedded-highlighter
        ]
        ++ extensions;
      globalSnippets = globalSnippets;
      userSettings = userSettings // {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
      };
      keybindings = keybindings;
    };

    profiles.python = {
      extensions =
        with pkgs.nix-vscode-extensions.vscode-marketplace;
        [
          ms-python.python
        ]
        ++ extensions;
      globalSnippets = globalSnippets;
      userSettings = userSettings;
      keybindings = keybindings;
    };

    profiles.rust = {
      extensions =
        with pkgs.nix-vscode-extensions.vscode-marketplace;
        [
          rust-lang.rust-analyzer
        ]
        ++ extensions;
      globalSnippets = globalSnippets;
      userSettings = userSettings;
      keybindings = keybindings;
    };
  };
}

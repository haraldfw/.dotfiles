_: {
  # Claude Code keybindings, see https://code.claude.com/docs/en/keybindings
  # Restart Claude Code after changing this, it reads the file on startup.
  home.file.".claude/keybindings.json".text = builtins.toJSON {
    "$schema" = "https://www.schemastore.org/claude-code-keybindings.json";
    "$docs" = "https://code.claude.com/docs/en/keybindings";
    bindings = [
      {
        # Escape does a dozen different things in Claude Code (cancel, rewind menu
        # on double-tap, ...). Unbound in the chat prompt so it can't be hit by
        # accident. Ctrl+C still interrupts a running response.
        context = "Chat";
        bindings = {
          escape = null;
        };
      }
    ];
  };
}

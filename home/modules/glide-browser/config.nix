_: {
  # Glide keybindings. Managed separately from the browser itself: on macos Glide is
  # installed from a Homebrew cask (systems/nixbook), on linux from the Nix package
  # (./default.nix, which also sets policies/extensions).
  xdg.configFile."glide/glide.ts".text = ''
    // <leader>-bindings
    glide.keymaps.set("normal", "<leader>t", "tab_new", { description: "Open a new tab" });
    glide.keymaps.set("normal", "<leader>T", "tab_reopen", { description: "Reopen last closed tab" });

    glide.keymaps.set("normal", "<leader>n", async () => {
      await glide.findbar.close();
    }, { description: "Close findbar" });

    // Vim-style find: / opens findbar, n/N step through matches
    glide.keymaps.set("normal", "/", async () => {
      await glide.findbar.open({ query: "", mode: "normal" });
    });
    glide.keymaps.set("normal", "n", async () => {
      await glide.findbar.next_match();
    });
    glide.keymaps.set("normal", "N", async () => {
      await glide.findbar.previous_match();
    });
  '';
}

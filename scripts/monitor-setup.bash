# Copy contents to a temporary working directory, L = resolve soft links, r = recursive
cp -Lr ~/.config/hyprdynamicmonitors /tmp/
chmod -R +w /tmp/hyprdynamicmonitors

# Run TUI on the temporary copy
hyprdynamicmonitors tui --config /tmp/hyprdynamicmonitors/config.toml

# Copy changes back to Nix config
cp -r /tmp/hyprdynamicmonitors/* ~/.dotfiles/home/hyprland/monitors/.

echo Removing temp files...
rm -rf /tmp/hyprdynamicmonitors

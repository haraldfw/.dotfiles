# Nixbook

This the config that is deployed on macos.

## Manual steps

Because this is macos we cannot configure everything, this is an exhaustive list of manual steps
that need to be performed to get the config fully initialized.

### Before the first sync

1. Install Nix (the Determinate or upstream installer).
2. Install [Homebrew](https://brew.sh). nix-darwin's `homebrew` module manages the casks and brews
   in `default.nix`, but it does not install Homebrew itself.
3. Clone this repo to `~/.dotfiles`.
4. Run `./scripts/create-codesign-cert.bash` to create a local code-signing certificate. It asks
   for your password to trust the certificate. See [Privacy & Security permissions](#privacy--security-permissions)
   for why.
5. Run `./scripts/sync-darwin.bash`.

### Keyboard layout

The activation script copies the "US Intl without dead keys" layout to `~/Library/Keyboard Layouts`,
but macOS won't select it for you:

1. Log out and back in, so macOS picks up the new layout.
2. System Settings → Keyboard → Text Input → Input Sources → Edit → `+` → add
   "US Intl without dead keys". Remove the other input sources.

### Karabiner-Elements

Karabiner does all modifier remapping: the right Option/Command swap, Caps Lock → Escape, and left
Option → AeroSpace. See `home/modules/karabiner`.

1. Open Karabiner-Elements once and approve everything it asks for:
   - System Settings → General → Login Items & Extensions → Driver Extensions: enable
     `Karabiner-DriverKit-VirtualHIDDevice`. Jamf may block it, in which case Sikt IT has to allow it.
   - Privacy & Security → Input Monitoring: enable `karabiner_grabber` / Karabiner-Core-Service.
2. In Karabiner's Devices tab, check that every keyboard has "Modify events" enabled.
3. Don't use System Settings → Keyboard → Modifier Keys. Karabiner takes over the keyboards, so
   those settings are ignored.
4. Don't edit settings in the Karabiner GUI. `karabiner.json` is a read-only Nix symlink, so
   change the Nix module instead.
5. A new external keyboard needs its own rules in the Karabiner module. Get its vendor/product ID
   from `hidutil list --matching keyboard` or Karabiner-EventViewer → Devices.

### Privacy & Security permissions

Grant these in System Settings → Privacy & Security:

| Permission         | App                                             | Why                                                                                     |
| ------------------ | ----------------------------------------------- | --------------------------------------------------------------------------------------- |
| Accessibility      | AeroSpace                                       | Needed to move and resize windows                                                       |
| Full Disk Access   | Alacritty (`~/Applications/Home Manager Apps/`) | No prompts when entering Desktop, Documents, Downloads, iCloud, network and USB volumes |
| App Management     | Alacritty                                       | No prompts when the sync script updates apps (home-manager apps, Homebrew casks)       |
| Developer Tools    | Alacritty (optional)                            | Skips Gatekeeper checks for binaries started from the terminal, so they start faster  |

Glide may also ask for Camera, Microphone or Screen Recording when a site needs them.

Nix builds apps with throwaway signatures that aren't tied to a certificate, so macOS would
track them by a fingerprint of the binary and drop their permissions on every rebuild. To prevent
that, every app in `~/Applications/Home Manager Apps` is re-signed with the `nixbook-codesign`
certificate on each sync (`home/modules/codesign-apps`), and the permissions stick to that
certificate instead. This means:

- Grant permissions to the apps in `~/Applications/Home Manager Apps`, not to anything in
  `/nix/store`. AeroSpace's launch agent runs that copy too.
- Install GUI apps through home-manager (`home.packages` / `programs.*`), not nix-darwin, so they
  end up in that folder and get signed.
- If the certificate is missing, the sync prints a warning and the apps stay ad-hoc signed.
- After an AeroSpace update, restart it (log out, or
  `launchctl kickstart -k gui/$UID/org.nix-community.home.aerospace`). Its path doesn't change, so
  launchd won't restart it on its own.
- Moving to a new certificate, or setting this up for the first time, means removing the apps' old
  entries in each Privacy & Security list and adding them again once.

CLI tools started from Alacritty (nvim, git, ...) use Alacritty's permissions, so they need no
signing.

# Nixbook

This the config that is deployed on macos.

## Manual steps

Because this is macos we cannot configure everything, this is an exhaustive list of manual steps
that need to be performed to get the config fully initialized.

### Before the first sync

1. Install Nix (the Determinate or upstream installer).
2. Install [Homebrew](https://brew.sh). nix-darwin's `homebrew` module manages the casks and brews
   in `default.nix`, but it does not install Homebrew itself.
3. Clone this repo to `~/.dotfiles` and run `./scripts/sync-darwin.bash`.

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

Nix builds Alacritty and AeroSpace with throwaway signatures that aren't tied to a certificate, so
macOS tracks them by a fingerprint of the binary. Whenever a flake update rebuilds one of them,
macOS treats it as a new app, and its permissions have to be granted again.

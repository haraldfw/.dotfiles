{ config, ... }:
let
  aerospace = "${config.programs.aerospace.package}/bin/aerospace";

  # left Option + key (+ extra modifiers) -> run an aerospace command.
  # AeroSpace can't tell left/right Option apart, so these bindings live here
  # instead, leaving right Option free to type æ/ø/å via the keyboard layout.
  leftOptionToAerospace = key: extraMods: command: {
    type = "basic";
    from = {
      key_code = key;
      modifiers.mandatory = [ "left_option" ] ++ extraMods;
    };
    to = [ { shell_command = "${aerospace} ${command}"; } ];
  };

  # Karabiner seizes the keyboards, so macOS' per-keyboard "Modifier Keys"
  # settings no longer apply. Per-device remaps are done here instead.
  builtInKeyboard = {
    is_built_in_keyboard = true;
  };
  # PC-layout USB keyboard ("USB Keyboard", 0x04d9:0x0169)
  usbKeyboard = {
    vendor_id = 1241;
    product_id = 361;
  };
  # PC-layout keyboard used at home ("USB Keyboard", 0x0c45:0x7692)
  homeKeyboard = {
    vendor_id = 3141;
    product_id = 30354;
  };

  remapOn = device: from: to: {
    type = "basic";
    from = {
      key_code = from;
      modifiers.optional = [ "any" ];
    };
    to = [ { key_code = to; } ];
    conditions = [
      {
        type = "device_if";
        identifiers = [ device ];
      }
    ];
  };
in
{
  # Karabiner replaces this symlink with a real file whenever it saves (e.g. when
  # it sees a new device), which would make home-manager refuse to switch.
  # force = true overwrites it without a backup.
  xdg.configFile."karabiner/karabiner.json".force = true;

  # read-only nix symlink: edits made in the Karabiner GUI won't persist
  xdg.configFile."karabiner/karabiner.json".text = builtins.toJSON {
    profiles = [
      {
        name = "Default";
        selected = true;
        virtual_hid_keyboard.keyboard_type_v2 = "ansi";

        complex_modifications.rules = [
          {
            # Mac layout: Option next to the spacebar on the right, like AltGr
            description = "Built-in keyboard: swap right Option/Command, Caps Lock -> Escape";
            manipulators = [
              (remapOn builtInKeyboard "right_option" "right_command")
              (remapOn builtInKeyboard "right_command" "right_option")
              (remapOn builtInKeyboard "caps_lock" "escape")
            ];
          }
          {
            # PC layout: Win key acts as Option (AeroSpace), Alt as Command.
            # The right side is left as-is: AltGr next to the spacebar is already right Option.
            description = "USB keyboard: swap left Option/Command, Caps Lock -> Escape";
            manipulators = [
              (remapOn usbKeyboard "left_option" "left_command")
              (remapOn usbKeyboard "left_command" "left_option")
              (remapOn usbKeyboard "caps_lock" "escape")
            ];
          }
          {
            # same layout as the other PC keyboard, but no Caps Lock remap
            description = "Home keyboard: swap left Option/Command";
            manipulators = [
              (remapOn homeKeyboard "left_option" "left_command")
              (remapOn homeKeyboard "left_command" "left_option")
            ];
          }
          {
            description = "Left Option -> AeroSpace (keeps right Option for æøå)";
            manipulators = [
              (leftOptionToAerospace "l" [ "shift" ] "move right")
              (leftOptionToAerospace "w" [ ] "close")
              (leftOptionToAerospace "l" [ ] "focus right")
            ];
          }
        ];
      }
    ];
  };
}

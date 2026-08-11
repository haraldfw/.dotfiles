{ config, lib, ... }:
{
  imports = [
    ./keybindings-dict.nix
  ];
  home.activation.installKeyboardLayout = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/Library/Keyboard Layouts"
    $DRY_RUN_CMD chmod -R u+w "${config.home.homeDirectory}/Library/Keyboard Layouts/us-intl-no-dead-keys.bundle" 2>/dev/null || true
    $DRY_RUN_CMD rm -rf "${config.home.homeDirectory}/Library/Keyboard Layouts/us-intl-no-dead-keys.bundle"
    $DRY_RUN_CMD cp -RL ${./us-intl-no-dead-keys.bundle} "${config.home.homeDirectory}/Library/Keyboard Layouts/us-intl-no-dead-keys.bundle"
    $DRY_RUN_CMD chmod -R u+w "${config.home.homeDirectory}/Library/Keyboard Layouts/us-intl-no-dead-keys.bundle"
  '';

  launchd.agents.swap-right-option-cmd = {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/hidutil"
        "property"
        "--set"
        ''{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x7000000E6,"HIDKeyboardModifierMappingDst":0x7000000E7},{"HIDKeyboardModifierMappingSrc":0x7000000E7,"HIDKeyboardModifierMappingDst":0x7000000E6}]}''
      ];
      RunAtLoad = true;
    };
  };
}

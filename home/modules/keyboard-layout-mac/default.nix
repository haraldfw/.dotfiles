{ config, lib, ... }:
{
  home.activation.installKeyboardLayout = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/Library/Keyboard Layouts"
    $DRY_RUN_CMD rm -rf "${config.home.homeDirectory}/Library/Keyboard Layouts/us-intl-no-dead-keys.bundle"
    $DRY_RUN_CMD cp -RL ${../../files/keyboard-layouts/us-intl-no-dead-keys.bundle} "${config.home.homeDirectory}/Library/Keyboard Layouts/us-intl-no-dead-keys.bundle"
  '';
}

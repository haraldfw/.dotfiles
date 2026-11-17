{ config, lib, ... }:
let
  # created by scripts/create-codesign-cert.bash
  identity = "nixbook-codesign";
  dir = "${config.home.homeDirectory}/${config.targets.darwin.copyApps.directory}";
in
{
  # Nix-built apps are ad-hoc signed (or unsigned), so macOS identifies them by
  # binary hash and drops their privacy permissions (Full Disk Access, App
  # Management, Accessibility, ...) whenever they are rebuilt. Re-signing them
  # with a stable local certificate makes the permissions persist.
  #
  # copyApps' rsync reverts the signatures on every sync, so this runs every
  # time, and before launch agents are (re)started so they never run an
  # unsigned copy.
  home.activation.codesignApps = lib.hm.dag.entryBetween [ "setupLaunchAgents" ] [ "copyApps" ] ''
    if /usr/bin/security find-identity -v -p codesigning | grep -q '"${identity}"'; then
      for app in '${dir}'/*.app; do
        [[ -d "$app" ]] || continue
        # leave vendor-signed apps (with a real Team ID) alone
        if /usr/bin/codesign -dv "$app" 2>&1 | grep -q '^TeamIdentifier=[A-Z0-9]\{10\}$'; then
          continue
        fi
        run /usr/bin/codesign --force --deep --preserve-metadata=entitlements \
          --sign '${identity}' "$app" \
          || echo "warning: failed to codesign $app" >&2
      done
    else
      echo "warning: code-signing identity '${identity}' missing, run scripts/create-codesign-cert.bash" >&2
    fi
  '';
}

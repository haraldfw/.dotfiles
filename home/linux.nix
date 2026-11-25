{ ... }:
{
  # tux and tuxollini: the shared linux setup plus personal-only modules.
  # Host-specific installs for the work laptop live in hosts/work.nix instead.
  imports = [
    ./linux-common.nix
    ./modules/obsidian
  ];
}

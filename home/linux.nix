{ ... }:
{
  # tux and tuxollini: the shared linux setup. Personal-only modules would be added here.
  # Host-specific installs for the work laptop live in hosts/work.nix instead.
  imports = [ ./linux-common.nix ];
}

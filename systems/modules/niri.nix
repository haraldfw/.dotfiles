{ ... }:
{
  # Provided by sodiboo/niri-flake (nixosModules.niri, imported in flake.nix).
  # Start from a TTY with `niri-session`.
  programs.niri.enable = true;

  # Binary cache for niri-flake's niri builds.
  nix.settings = {
    substituters = [ "https://niri.cachix.org" ];
    trusted-public-keys = [ "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=" ];
  };
}

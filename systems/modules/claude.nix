{ inputs, pkgs, ... }:
{
  nixpkgs.overlays = [
    inputs.claude-desktop.overlays.default
  ];

  environment.systemPackages = with pkgs; [
    claude-desktop
    # claude-desktop-fhs  # use this variant instead if you want MCP server support (npx/uvx/docker)
  ];
}

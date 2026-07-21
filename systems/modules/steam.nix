{ pkgs, ... }:
{
  programs = {
    gamescope.enable = true;
    gamemode.enable = true;

    steam = {
      enable = true;
      gamescopeSession.enable = true;
      # steam remote play port
      remotePlay.openFirewall = true;
      # port for local network download between steam clients
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  hardware.graphics.enable32Bit = true;
  environment.systemPackages = [ pkgs.steam ];
}

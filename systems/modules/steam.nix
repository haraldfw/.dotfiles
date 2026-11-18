{ pkgs, ... }:
{
  programs = {
    gamescope.enable = true;
    gamemode = {
      enable = true;
      # Don't let GameMode hold a screensaver inhibit for as long as a game (e.g.
      # Battle.net via Lutris) is running; that blocked hypridle's dim/lock/dpms.
      settings.general.inhibit_screensaver = 0;
    };

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

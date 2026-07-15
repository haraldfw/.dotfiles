{
  pkgs,
  inputs,
  username,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  users = {
    defaultUserShell = pkgs.zsh;
    users.${username} = {
      isNormalUser = true;
      description = "${username}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "uinput" # needed for kanata
        "gamemode" # needed for gamemode
      ];
      shell = pkgs.zsh;
    };
  };

  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;

  nix.settings.allowed-users = [ "${username}" ];
}

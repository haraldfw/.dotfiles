{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./extra.nix
    ./../../modules/core
  ];

  powerManagement.cpuFreqGovernor = "performance";
}

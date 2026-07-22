

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lm_sensors
    linuxKernel.packages.linux_6_18.cpupower
  ];

  services.openssh.enable = true;
  services.upower.enable = true;
}

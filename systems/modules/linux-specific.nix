{ ... }:
{
  services = {
    openssh.enable = true;
    upower.enable = true;
  };

  # systemd.sleep.settings.Sleep = {
  #   HibernateDelaySec = "1h";
  # };

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };
}

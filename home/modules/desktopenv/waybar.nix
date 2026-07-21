{ ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        height = 30;
        spacing = 4;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
          "custom/media"
          "hyprland/window"
        ];
        modules-center = [
        ];
        modules-right = [
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "tray"
          "battery"
          "clock"
        ];
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
            "6" = [ ];
          };
          format-icons = {
            active = "■";
          };
        };
        "hyprland/submap" = {
          format = "<span style=\"italic\">{}</span>";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        clock = {
          timezone = "Europe/Oslo";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{}% ";
        };
        battery = {
          format = "{capacity}% {icon}";
          states = {
            "good" = 95;
            "warning" = 30;
            "critical" = 15;
          };
          "format-full" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% {icon} ⚡";
          "format-plugged" = "{capacity}% {icon} ⚡";
          "format-alt" = "{time} {icon}";
          "format-icons" = [
            "🪫"
            "🔋"
          ];

        };
        network = {
          # "interface"="wlp2*", # (Optional) To force the use of this interface
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}={ipaddr}/{cidr}";
        };
        pulseaudio = {
          # "scroll-step"=1, # %, can be a float
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };
      };
    };
  };
}

{ config, lib, pkgs, ... }:

{
    programs.waybar = {
        enable = true;
        systemd = {
            enable = true;
            target = "hyprland-session.target";
        };

        settings.main = {
            layer = "top";

            # Bar

            modules-left = ["hyprland/workspaces"];
            modules-center = ["bluetooth" "clock" "custom/microphone"];
            modules-right = ["wireplumber" "temperature" "memory" "disk" "cpu" "network" "battery"];

            # Modules

            "hyprland/workspaces" = {
                all-outputs = true;
                persistent-workspaces = {
                    "*" = [1 2 3 4 5 6 7 8 9 10];
                };
            };

            "custom/microphone" = {
                interval = 3;
                exec = "wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q 'MUTED' && echo ''";
                on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
            };

            wireplumber = {
                format = "{volume}% ";
                format-muted = "";
                max-volume = 150;
                scroll-step = 0.5;
            };

            temperature = {
                format = "{temperatureC}°C ";
                format-critical = "{temperatureC}°C ";
                critical-threshold = 80;
            };

            network = {
                interval = 30;
                format = "?";
                format-disconnected = "";
                format-wifi = "";
                format-ethernet = "󰈀";
                tooltip-format = "{ipaddr}";
            };

            bluetooth = {
                format = "";
                format-on = "";
                format-connected = "󰂱";
            };

            memory = {
                interval = 5;
                format = "{}% ";
                max-length = 10;
                states = {
                    critical = 85;
                };
            };

            disk = {
                interval = 120;
                format = "{percentage_used}% ";
                path = "/";
                states = {
                    critical = 85;
                };
            };

            cpu = {
                interval = 5;
                format = "{}% ";
                max-length = 10;
            };

            battery = {
                interval = 10;
                format = "{capacity}% {icon}";
                format-charging = "{capacity}% {icon}";
                format-icons = {
                    discharging = ["" "" "" "" ""];
                    charging = "";
                    "Not charging" = "";
                };
                states = {
                    critical = 15;
                };
            };

            clock = {
                format-alt = "{:%a, %d. %b  %H:%M}";
            };
        };
    };
}

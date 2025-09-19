{ lib, ... }:

{
    programs.waybar = {
        enable = true;
        systemd.enable = true;

        style = lib.mkAfter ''
            #workspaces button.empty {
                opacity: 0.5;
            }

            #workspaces button.active {
                color: @base0B;
                opacity: 1;
            }

            label.module, box.module, .modules-right {
                padding: 0 10px;
            }

            .modules-right .module {
                margin: 0 10px;
            }

            #clock {
                font-size: 17px;
            }

            #temperature.critical,
            #network.disconnected,
            #disk.critical,
            #battery.critical,
            #memory.critical {
                font-weight: bold;
                color: @base08;
            }
        '';

        settings.main = {
            layer = "top";

            # Bar

            modules-left = [];
            modules-center = ["bluetooth" "clock" "custom/microphone"];
            modules-right = ["wireplumber" "temperature" "memory" "disk" "cpu" "network" "battery"];

            # Modules
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
                    full = "";
                };
                states = {
                    critical = 15;
                    full = 100;
                };
            };

            clock = {
                format-alt = "{:%a, %d. %b  %H:%M}";
            };
        };
    };
}

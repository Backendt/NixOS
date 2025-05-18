{ config, lib, pkgs, ... }:

{
    programs.waybar.style = lib.mkAfter ''
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
}

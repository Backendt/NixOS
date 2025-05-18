{ config, lib, pkgs, ... }:

{
    programs.wofi.style = lib.mkForce ''
        window {
            font-family: "JetBrains Mono";
            font-size: 10;
            background-color: #${config.lib.stylix.colors.base00};
        }

        #entry:nth-child(odd) {
            background-color: #${config.lib.stylix.colors.base00};
        }

        #entry:nth-child(even) {
            background-color: #${config.lib.stylix.colors.base01};
        }

        #entry:selected {
            background-color: #${config.lib.stylix.colors.base0D};
            color: #${config.lib.stylix.colors.base01};
        }

        #entry:selected label {
            color: #${config.lib.stylix.colors.base01};
        }

        #input {
            background-color: #${config.lib.stylix.colors.base01};
            color: #${config.lib.stylix.colors.base04};
            border-color: #${config.lib.stylix.colors.base0D};
        }

        #input:focus {
            border-color: #${config.lib.stylix.colors.base05};
        }
    '';
}

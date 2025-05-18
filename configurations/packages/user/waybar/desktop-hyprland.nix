{ config, pkgs, ... }:

{
    imports = [ ./hyprland.nix ];

    programs.waybar.settings.main = {
        # Only display waybar on main monitor
        output = "DP-1";

        # Change the temperature zone used for CPU
        temperature.thermal-zone = 2;
    };

}

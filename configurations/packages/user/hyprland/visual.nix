{ config, pkgs, ... }:

{
   wayland.windowManager.hyprland.settings = {
        
        general = {
            gaps_in = 5;
            gaps_out = 10;
            border_size = 2;
        };

        decoration = {
            rounding = 6;
            shadow.enabled = false;

            blur = {
                enabled = true;
                size = 6;
                passes = 1;
                new_optimizations = true;
            };
        };

        animations = {
            enabled = true;
            bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
            animation = [
                "windows, 1, 2, myBezier"
                "windowsOut, 1, 7, default, popin 80%"
                "border, 1, 10, default"
                "borderangle, 1, 8, default"
                "fade, 0, 3, default"
                "workspaces, 1, 2, default"
            ];
        };

   };
}

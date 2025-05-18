{ config, inputs, pkgs, lib, ... }:

{
    imports = [ inputs.stylix.homeManagerModules.stylix ];

    stylix = {
        enable = true;
        autoEnable = true;
        polarity = "dark";

        fonts = {
            monospace = {
                package = pkgs.jetbrains-mono;
                name = "JetBrains Mono";
            };

            sansSerif = {
                package = pkgs.jetbrains-mono;
                name = "TeX Gyre Heros";
            };
        };
    };

    home.pointerCursor = lib.mkForce {
        gtk.enable = true;
        package = pkgs.phinger-cursors;
        name = "phinger-cursors-light";
        size = 32;
    };
}

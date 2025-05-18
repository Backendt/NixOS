{ config, lib, pkgs, ... }:

{
    xdg.configFile."vesktop/themes/poimandres.theme.css".text = ''
    /**
    * @name Poimandres
    * @description Use this instead of Stylix theme
    **/
        @import "stylix.theme.css";

        .theme-light, .theme-dark {
            --background-mentioned: rgba(93, 228, 199, 0.15);
            --background-mentioned-hover: rgba(93, 228, 199, 0.1);
            --info-warning-foreground: var(--base06);
        }
    '';
}

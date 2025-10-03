{ lib, pkgs, ... }:

{
    programs.kitty.extraConfig = lib.mkAfter "include ${pkgs.kitty-themes}/share/kitty-themes/themes/Catppuccin-Mocha.conf";
}

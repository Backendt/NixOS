{ pkgs, ... }:

{
    imports = [ ./mako.nix ];

    home.packages = with pkgs; [
        grim
        slurp
        wl-clipboard
    ];

    programs.wofi.enable = true;
}

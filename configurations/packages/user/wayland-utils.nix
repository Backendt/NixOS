{ pkgs, ... }:

{
    imports = [ ./mako.nix ];

    home.packages = with pkgs; [
        grim
        slurp
        wl-clipboard
        wlvncc
    ];

    programs.wofi.enable = true;
}

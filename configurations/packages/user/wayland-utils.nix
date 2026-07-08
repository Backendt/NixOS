{ pkgs, ... }:

{
    imports = [ ./mako.nix ];

    home.packages = with pkgs; [
        grim
        slurp
        wl-clipboard
        wlvncc
    ];

    services.walker.enable = true;
    services.elephant.enable = true;
}

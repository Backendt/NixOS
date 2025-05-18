{ config, pkgs, ... }:

{
    imports = [
        ./common.nix
        ./overrides/poimandres/waybar.nix
        ./overrides/poimandres/neovim.nix
        ./overrides/poimandres/nixvim.nix
        ./overrides/poimandres/wofi.nix
        ./overrides/poimandres/vesktop.nix
    ];

    stylix = {
        image = ./wallpapers/night-nature.jpg;
        base16Scheme = ./styles/poimandres.yaml;

        opacity = {
            terminal = 0.7;
            desktop = 0.4;
        };
    };
}

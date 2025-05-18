{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        python3
        python311Packages.requests
        jetbrains.idea-community
        jdk
        cargo
        rustc
        gcc
        rustfmt
        vscodium
    ];
}

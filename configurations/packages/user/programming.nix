{ pkgs, ... }:

{
    home.packages = with pkgs; [
        python313Full
        python313Packages.requests
        jetbrains.idea-community
        jdk
        cargo
        rustc
        gcc
        rustfmt
        vscodium
    ];
}

{ pkgs, ... }:

{
    home.packages = with pkgs; [
        python313
        python313Packages.requests
        jetbrains.idea
        jdk
        cargo
        rustc
        gcc
        gnumake
        rustfmt
        vscodium
    ];

    programs.yarn.enable = true;
}

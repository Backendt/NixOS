{ pkgs, ... }:

{
    home.packages = with pkgs; [
        python313
        python313Packages.requests
        jetbrains.idea-community
        jdk
        cargo
        rustc
        gcc
        rustfmt
        vscodium
    ];

    programs.yarn.enable = true;
}

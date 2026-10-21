{ inputs, pkgs, ... }:

{
    imports = [inputs.walker.homeManagerModules.default];
    programs.walker = {
        enable = true;
        runAsService = true;
    };

    gtk = {
        enable = true;
        iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
        };
    };
}

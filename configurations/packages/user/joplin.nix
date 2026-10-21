{ pkgs, ... }:

{
    programs.joplin-desktop = {
        enable = true;
        package = pkgs.unstable.joplin-desktop;
        general.editor = "nvim";
    };
}

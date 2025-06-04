{ pkgs, ... }:

{
    programs.gpg.enable = true;
    services.gpg-agent = {
        enable = true;
        enableBashIntegration = true;
        pinentryPackage = pkgs.pinentry-curses;
    };
}

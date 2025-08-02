{ pkgs, ... }:

{
    services.printing = {
        enable = true;
        package = pkgs.unstable.cups;
        cups-pdf.enable = true;
        openFirewall = true;
        drivers = with pkgs.unstable; [ hplipWithPlugin gutenprint canon-cups-ufr2 cups-filters ];
    };

    environment.systemPackages = [ pkgs.unstable.poppler_utils ];
}

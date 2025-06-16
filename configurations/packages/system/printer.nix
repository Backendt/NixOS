{ pkgs, ... }:

{
    services.printing = {
        enable = true;
        cups-pdf.enable = true;
        openFirewall = true;
        drivers = with pkgs; [ hplipWithPlugin gutenprint canon-cups-ufr2 cups-filters ];
    };

    environment.systemPackages = [ pkgs.poppler_utils ];
}

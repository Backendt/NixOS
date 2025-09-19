{ pkgs, ... }:

{
    environment.systemPackages = [ pkgs.libnfc pkgs.libusb1 ];

    # TODO Or disable it ?
    hardware.nfc-nci.enable = true;
}

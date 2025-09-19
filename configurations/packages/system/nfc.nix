{ pkgs, ... }:

{
    environment.systemPackages = [ pkgs.pcsc-tools pkgs.libnfc ];

    services.pcscd = {
        enable = true;
        plugins = [ pkgs.ccid ];
    };

    services.udev.extraRules = ''
       SUBSYSTEM=="usb", ATTRS{idVendor}=="072f", ATTRS{idProduct}=="2200", GROUP="users", MODE="0666"
    '';
    boot.blacklistedKernelModules = [ "pn533_usb" ];
}

{
    imports = [ ./hardware/desktop-hardware-configuration.nix ];

    networking = {
        hostName = "nixos-desktop";
        wireless.enable = false;
        networkmanager.enable = true;
    };

    # Disable mouse acceleration in X11
    services.libinput.mouse.accelProfile = "flat";
}

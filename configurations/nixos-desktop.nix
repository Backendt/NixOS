{
    imports = [
        ./hardware/desktop-hardware-configuration.nix
        ./packages/system/nvidia.nix
        ./packages/system/pipewire/desktop.nix
        ./packages/system/gaming.nix
    ];

    networking = {
        hostName = "nixos-desktop";
        wireless.enable = false;
        networkmanager.enable = true;
    };

    # Disable mouse acceleration in X11
    services.libinput.mouse.accelProfile = "flat";
}

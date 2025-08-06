{
    imports = [
        ./hardware/laptop-hardware-configuration.nix
    ];

    networking.hostName = "nixos-laptop";

    # TLP Power management
    services.tlp.enable = true;
}

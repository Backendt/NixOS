{ config, pkgs, ... }:

{
    services.mako = {
        enable = true;
        layer = "overlay";

        borderRadius = 5;
        defaultTimeout = 3500; # In milliseconds
    };
}

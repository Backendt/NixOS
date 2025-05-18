{ config, pkgs, ... }:

{
    networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 4444 8080 8081 ];
    };
}
